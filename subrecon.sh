#!/bin/bash

#Initialize variables
domain=""
output=""
wordlist=""
threads=0
verbose=false
current_dir=($pwd)

#Define function to display usage
usage(){
	echo "Usage: $0 -d <domain> -o <output directory> -x <wordlist> , Optional: -t <threads> -v <Verbose (true/false)> "
	}

#Define function to display error with usage
error(){
	usage
	exit 
	}
	
#check if any arguments are given 
if [ $# -eq 0 ]; then
	error
fi

#Take flags
while getopts "d:o:x:t:vh" flag; do
  case $flag in
    d) domain="$OPTARG" ;;
    o) output="$OPTARG" ;;
    x) wordlist="$OPTARG" ;;
    t) threads="$OPTARG" ;;
    v) verbose=true ;;
    h) usage 
       exit ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        usage 
        exit ;;
  esac
done

echo 'This tool uses dnsrecon, gobuster, and assetfinder for finding subdomains and performs httprobe on the combined output!'

#check for missing compulsory arguments
if [ -z "$domain" ] || [ -z "$output" ] ; then
  echo "One of the arguments missing. Check usage with -h"
fi

#change current directory to 'output'
cd $output

#Command config
if [ "$threads" -eq 0 ] && [ "$verbose" = "false" ]; then    #when no optional flags are given
    sudo dnsrecon -d "$domain" -j dnsrecon.json  -t axfr,crt,zonewalk,bing
    echo "-------------------------"
    echo "Starting Gobuster"
    sudo gobuster dns -d "$domain" -o gobuster.txt -w "$wordlist"
    echo "-------------------------"
    echo "Starting AssetFinder!" 
    echo "-------------------------"
    sudo assetfinder --subs-only "$domain" | anew assetfinder.txt
    echo "-------------------------"
    echo "Finished!"
    echo "-------------------------"
elif [ "$threads" -eq 0 ] && [ "$verbose" = "true" ]; then	 #when only -v optional flag is given
    sudo dnsrecon -d "$domain" -j dnsrecon.json -v -t axfr,crt,zonewalk,bing
    echo "-------------------------"
    echo "Starting Gobuster"
    sudo gobuster dns -d "$domain" -o gobuster.txt -v -w "$wordlist"
    echo "-------------------------"
    echo "Starting AssetFinder!"
    echo "-------------------------"
    sudo assetfinder --subs-only "$domain" | anew assetfinder.txt
    echo "-------------------------"
    echo "Finished!"
    echo "-------------------------"
elif [ "$threads" -ne 0 ] && [ "$verbose" = "false" ]; then	 #when only -t optional flag is given
    sudo dnsrecon -d "$domain" -j dnsrecon.json --threads "$threads" -t axfr,crt,zonewalk,bing
    echo "-------------------------"
    echo "Starting Gobuster"
    sudo gobuster dns -d "$domain" -o gobuster.txt -t "$threads" -w "$wordlist" 
    echo "-------------------------"
    echo "Starting AssetFinder!"
     echo "-------------------------"
    sudo assetfinder --subs-only "$domain" | anew assetfinder.txt
     echo "-------------------------"
    echo "Finished!"
     echo "-------------------------"
else							#when both -v and -t optional flags are given
    sudo dnsrecon -d "$domain" -j dnsrecon.json --threads "$threads" -v -t axfr,bing,crt,zonewalk
    echo "-------------------------"
    echo "Starting Gobuster"
    sudo gobuster dns -d "$domain" -o gobuster.txt -w "$wordlist" -v -t "$threads"
    echo "-------------------------"
    echo "Starting AssetFinder!"
     echo "-------------------------"
    sudo assetfinder --subs-only "$domain" | anew assetfinder.txt
    echo "-------------------------"
    echo "Finished!"
    echo "-------------------------"
fi

#finds all the subdomains in .json file and then puts them in .txt and are unique subdomains.
cat dnsrecon.json | grep -o '"name": "[^"]*' | grep -o '[^"]*$' | sort -u > dnsrecon.txt 

#Remove all the 'found: ' in gobuster.txt
sudo grep -oP 'Found: \K.*' gobuster.txt > gobuster_subs.txt

#Makes a a text file containing unique subdomains from above 3 tool's output files.
cat gobuster_subs.txt >> combined_subdomains.txt
cat dnsrecon.txt >> combined_subdomains.txt
cat assetfinder.txt >> combined_subdomains.txt
cat combined_subdomains.txt | anew unique_combined_subdomains.txt

#Run the subdomains through httprobe to get the working/valid subdomains and save it in probe.txt
echo "-------------------------"
echo "Starting Httprobe!"
echo "-------------------------"
cat unique_combined_subdomains.txt | httprobe | anew probe.txt
echo "-------------------------"
echo "Finished!"
echo "-------------------------"
echo "Don't forget to use aquatone and vulnerability scanners!"
