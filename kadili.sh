#!/bin/bash

# Colors
green='\e[1;32m'
red='\e[1;31m'
yellow='\e[1;33m'
nc='\e[0m'

clear
cat banner.txt
echo
echo -e "${green}[1]${nc} Scan SQL Injection"
echo -e "${green}[2]${nc} Scan XSS Vulnerability"
echo -e "${green}[3]${nc} Find Admin Panel"
echo -e "${green}[4]${nc} Whois Lookup"
echo -e "${green}[5]${nc} Encode (Base64)"
echo -e "${green}[0]${nc} Exit"
echo
read -p $'\e[1;33mChoose an option: \e[0m' choice

case $choice in
    1)
        read -p "Enter target URL: " url
        echo "[*] Scanning for SQL Injection..."
        curl -s "$url'" | grep -i "sql" && echo "[!] Possible SQL Injection!" || echo "[+] Safe"
        ;;
    2)
        read -p "Enter target URL: " url
        echo "[*] Scanning for XSS..."
        curl -s "$url<script>alert(1)</script>" | grep -q "<script>alert(1)</script>" && echo "[!] Possible XSS!" || echo "[+] Safe"
        ;;
    3)
        read -p "Enter website (e.g., https://site.com): " site
        echo "[*] Searching for admin panel..."
        for path in admin login dashboard cp admincp administrator; do
            full="$site/$path"
            code=$(curl -o /dev/null -s -w "%{http_code}" "$full")
            if [[ $code == 200 ]]; then
                echo "[+] Found: $full"
            fi
        done
        ;;
    4)
        read -p "Enter domain: " domain
        echo "[*] Fetching WHOIS info..."
        whois $domain | head -n 20
        ;;
    5)
        read -p "Enter text to encode: " text
        echo -n "$text" | base64
        ;;
    0)
        echo -e "${yellow}Exiting Kadili Ghost... Stay safe!${nc}"
        ;;
    *)
        echo -e "${red}Invalid option!${nc}"
        ;;
esac

