# Subrecon
A Script that collects the results from various information gathering tools tools, extracts unique subdomains, and saves them into organized text files. Furthermore, it employs httprobe to identify active subdomains, providing a valuable list of live targets for penetration testing.

# What is Subdomain Enumeration
Subdomain enumeration is the process of discovering and cataloging subdomains
associated with a given domain name. Subdomains are prefixes to the main domain and
are used to organize and manage different sections or services of a website or network.
Enumerating subdomains is a critical phase in various cybersecurity activities, including
penetration testing, vulnerability assessment, and domain management.
1There are various subdomain enumeration techniques and tools that one can use to get the
desired output. Some of the most common ones are listed below with their corresponding
tool for the same.
1. Brute Force Enumeration: This technique generates subdomain names by
applying dictionaries and checks if they resolve to valid hosts. There are various
tools are enable us to perform subdomain enumeration on a target like gobuster,
oneforall.py, etc.
2. DNS Query Enumeration: In this technique the tools are querying the DNS
for subdomains related to a domain , essentially performing a DNS zone
transfer. The tools that are famous for this type of subdomain enumeration are
dnsrecon, dig, etc.
3. Certificate Transparency Logs: Certificate Transparency logs record
SSL/TLS certificates issued for subdomains and they might contain a list of
subdomains that the certificate is valid for , hence by querying these logs, we
can discover subdomains. Some of the tools used for this technique are crt.sh
and certspotter.
4. Web Scraping and Search Engine Queries: Various search engines index
subdomains , so we can extract those subdomains by using web scraping tools
for subdomains such as theHarvester, assetfinder , etc.
There are many other types of subdomain enumeration techniques that are being used , but
we have mentioned only the most commonly used ones and the ones that will be covered
in this project.

# Requirements:
Operating system  
• Kali linux 2023.3 with full dist upgrade  


Tools  
•Bash  
•Dnsrecon  
•Anew  
•Gobuster  
•Assetfinder  
•Httprobe  
•Seclists  
•Grep  
•Xfce or GNOME desktop environment


# Usage
Required Parameters  
-d = domain name  
-o = output directory  
-x = wordlist  
Optional Parameters  
-t = threads  
-v = verbose  
