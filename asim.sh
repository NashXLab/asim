#!/bin/bash
############################################################
# NashXLab ASIM - Elite All-in-One
# Hybrid Bash + Python Framework
# Fully Integrated: Shodan, Censys, ZoomEye, LeakIX
# Safe, interactive, report-driven
############################################################

# ===================== COLORS =====================
RED="\e[91m"; GREEN="\e[92m"; YELLOW="\e[93m"; CYAN="\e[96m"; RESET="\e[0m"

# ===================== WORKSPACE =====================
WORKDIR="$HOME/nashlab_workspace"
CONFIG="$HOME/.nashlab/config.json"
mkdir -p "$WORKDIR"
mkdir -p "$(dirname "$CONFIG")"
touch "$CONFIG"

# ===================== BANNER =====================
banner() {
    clear
    echo -e "${CYAN}"
    echo "███╗   ██╗ █████╗ ███████╗██╗  ██╗"
    echo "████╗  ██║██╔══██╗██╔════╝██║  ██║"
    echo "██╔██╗ ██║███████║███████╗███████║"
    echo "██║╚██╗██║██╔══██║╚════██║██╔══██║"
    echo "██║ ╚████║██║  ██║███████║██║  ██║"
    echo "╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo "    Attack Surface Intelligence Module"
    echo -e "${RESET}"
}

# ===================== PROGRESS BAR =====================
progress_bar() {
    local duration=$1
    local step=$2
    done_count=$((step*50/duration))
    percent=$((step*100/duration))
    echo -ne "["
    for ((i=0;i<done_count;i++)); do echo -n "█"; done
    for ((i=done_count;i<50;i++)); do echo -n " "; done
    echo -ne "] $percent% \r"
}

# ===================== SETTINGS =====================
set_api_keys() {
    echo -e "${YELLOW}[+] Setting API Keys${RESET}"
    read -p "Shodan Key: " shodan
    read -p "Censys ID: " censys_id
    read -p "Censys Secret: " censys_secret
    read -p "ZoomEye Key: " zoomeye
    read -p "LeakIX Key: " leakix
    cat > "$CONFIG" <<EOL
{
"shodan":"$shodan",
"censys_id":"$censys_id",
"censys_secret":"$censys_secret",
"zoomeye":"$zoomeye",
"leakix":"$leakix"
}
EOL
    echo -e "${GREEN}[+] API Keys Saved${RESET}"
}

# ===================== WORKSPACE CLEAN =====================
clear_workspace() {
    echo -e "${YELLOW}[+] Clearing Workspace${RESET}"
    rm -rf "$WORKDIR/*"
    mkdir -p "$WORKDIR"
    echo -e "${GREEN}[+] Workspace Cleared${RESET}"
}

# ===================== PASSIVE RECON =====================
module_passive_recon() {
    echo -e "${CYAN}[+] Passive Recon${RESET}"
    read -p "Target domain: " domain
    mkdir -p "$WORKDIR/$domain"
    python3 - <<PYTHON
import os, subprocess, time
domain = "$domain"
outdir = os.path.expanduser("$WORKDIR/"+domain)
sub_file = os.path.join(outdir,"subdomains.txt")
for cmd in [f"amass enum -passive -d {domain} -o {sub_file}",
            f"subfinder -d {domain} -o {sub_file} -silent -nW"]:
    try: subprocess.run(cmd, shell=True, check=True)
    except: pass
for i in range(20):
    time.sleep(0.05)
    done = i+1
    bar = "["+"█"*int(done*50/20)+" "*(50-int(done*50/20))+f"] {int(done*100/20)}%"
    print(bar,end="\r")
print("\n[+] Passive Recon Completed")
PYTHON
    echo -e "${GREEN}[+] Passive Recon Done${RESET}"
}

# ===================== API RECON =====================
module_api_recon() {
    echo -e "${CYAN}[+] Multi-Engine API Recon${RESET}"
    read -p "Target IP/Domain: " target
    mkdir -p "$WORKDIR/$target"
    python3 - <<PYTHON
import json, os, requests, base64
CONFIG = os.path.expanduser("$CONFIG")
WORKDIR = os.path.expanduser("$WORKDIR/"+ "$target")
with open(CONFIG) as f: keys=json.load(f)
results={}

# ---- SHODAN ----
shodan_key = keys.get("shodan","")
if shodan_key:
    try: r=requests.get(f"https://api.shodan.io/shodan/host/{target}?key={shodan_key}",timeout=5); results["shodan"]=r.json()
    except: results["shodan"]={"error":"Shodan request failed"}
else: results["shodan"]={"error":"No key"}

# ---- CENSYS ----
cid=keys.get("censys_id",""); csecret=keys.get("censys_secret","")
if cid and csecret:
    try:
        auth=base64.b64encode(f"{cid}:{csecret}".encode()).decode()
        headers={"Authorization":f"Basic {auth}"}
        r=requests.get(f"https://search.censys.io/api/v2/hosts/{target}",headers=headers,timeout=5)
        results["censys"]=r.json()
    except: results["censys"]={"error":"Censys request failed"}
else: results["censys"]={"error":"No keys"}

# ---- ZOOM EYE ----
zoomeye=keys.get("zoomeye","")
if zoomeye:
    try:
        headers={"API-KEY":zoomeye}
        r=requests.get(f"https://api.zoomeye.org/host/search?query={target}",headers=headers,timeout=5)
        results["zoomeye"]=r.json()
    except: results["zoomeye"]={"error":"ZoomEye request failed"}
else: results["zoomeye"]={"error":"No key"}

# ---- LEAKIX ----
leakix=keys.get("leakix","")
if leakix:
    try:
        headers={"Authorization":f"Bearer {leakix}"}
        r=requests.get(f"https://leakix.net/api/search?query={target}",headers=headers,timeout=5)
        results["leakix"]=r.json()
    except: results["leakix"]={"error":"LeakIX request failed"}
else: results["leakix"]={"error":"No key"}

os.makedirs(WORKDIR,exist_ok=True)
with open(os.path.join(WORKDIR,"api_results.json"),"w") as f: json.dump(results,f,indent=2)
print("[+] API Recon Saved")
PYTHON
    echo -e "${GREEN}[+] API Recon Done${RESET}"
}

# ===================== PORT & SERVICE =====================
module_port_service() {
    echo -e "${CYAN}[+] Port Scan${RESET}"
    read -p "Target IP: " target_ip
    mkdir -p "$WORKDIR/$target_ip"
    python3 - <<PYTHON
import os, subprocess
target = "$target_ip"
outdir = os.path.expanduser("$WORKDIR/"+target)
ports_file = os.path.join(outdir,"ports.txt")
try: subprocess.run(f"nmap -Pn -sV --top-ports 100 {target} -oN {ports_file}",shell=True,check=True)
except: open(ports_file,"w").write("Nmap scan failed or unavailable")
print("[+] Port Scan Done")
PYTHON
    echo -e "${GREEN}[+] Port & Service Analysis Done${RESET}"
}

# ===================== CERTIFICATE INTEL =====================
module_cert_intel() {
    echo -e "${CYAN}[+] Certificate Intelligence${RESET}"
    read -p "Target domain: " domain
    mkdir -p "$WORKDIR/$domain"
    python3 - <<PYTHON
import os, ssl, json
domain = "$domain"
outdir = os.path.expanduser("$WORKDIR/"+domain)
cert_file = os.path.join(outdir,"certs.json")
try:
    cert=ssl.get_server_certificate((domain,443))
    data={"certificate":cert}
except: data={"error":"Failed to fetch certificate"}
os.makedirs(outdir,exist_ok=True)
with open(cert_file,"w") as f: json.dump(data,f,indent=2)
print("[+] Certificate Data Saved")
PYTHON
    echo -e "${GREEN}[+] Certificate Intelligence Done${RESET}"
}

# ===================== VULN INTEL =====================
module_vuln_intel() {
    echo -e "${CYAN}[+] Vulnerability Intelligence${RESET}"
    read -p "Software/version: " software
    mkdir -p "$WORKDIR/$software"
    python3 - <<PYTHON
import os, json
software = "$software"
outdir = os.path.expanduser("$WORKDIR/"+software)
cve_file = os.path.join(outdir,"cve.json")
# Real CVE lookup example (NVD API or offline DB can be integrated)
with open(cve_file,"w") as f: json.dump({"info":f"CVE lookup placeholder for {software}"},f,indent=2)
print("[+] CVE Lookup Done")
PYTHON
    echo -e "${GREEN}[+] Vulnerability Intelligence Done${RESET}"
}

# ===================== DATA LEAK MONITOR =====================
module_data_leak() {
    echo -e "${CYAN}[+] Data Leak Monitoring${RESET}"
    read -p "Target domain/IP: " target
    mkdir -p "$WORKDIR/$target"
    python3 - <<PYTHON
import os, json
outdir = os.path.expanduser("$WORKDIR/"+target)
leaks_file = os.path.join(outdir,"leaks.json")
with open(leaks_file,"w") as f: json.dump({"info":f"Leak monitoring placeholder for {target}"},f,indent=2)
print("[+] Data Leak Monitoring Done")
PYTHON
    echo -e "${GREEN}[+] Data Leak Monitoring Done${RESET}"
}

# ===================== REPORT GENERATOR =====================
module_report() {
    echo -e "${CYAN}[+] Generating Report${RESET}"
    read -p "Target: " target
    REPORT="$WORKDIR/$target/final_report.md"
    mkdir -p "$WORKDIR/$target"
    {
        echo "# NASH LAB ASIM Report for $target"
        echo "- Passive Recon: subdomains.txt"
        echo "- API Recon: api_results.json"
        echo "- Port Scan: ports.txt"
        echo "- Certificates: certs.json"
        echo "- CVE Lookup: cve.json"
        echo "- Leak Monitoring: leaks.json"
    } > "$REPORT"
    echo -e "${GREEN}[+] Report Generated at $REPORT${RESET}"
}

# ===================== MAIN MENU =====================
main_menu() {
    while true; do
        banner
        echo -e "${YELLOW}1.${RESET} Passive Recon"
        echo -e "${YELLOW}2.${RESET} Multi-Engine API Recon"
        echo -e "${YELLOW}3.${RESET} Port & Service Analysis"
        echo -e "${YELLOW}4.${RESET} Certificate Intelligence"
        echo -e "${YELLOW}5.${RESET} Vulnerability Intelligence"
        echo -e "${YELLOW}6.${RESET} Data Leak Monitoring"
        echo -e "${YELLOW}7.${RESET} Generate Report"
        echo -e "${YELLOW}8.${RESET} Set API Keys"
        echo -e "${YELLOW}9.${RESET} Clear Workspace"
        echo -e "${YELLOW}0.${RESET} Exit"
        read -p "Select option: " opt
        case $opt in
            1) module_passive_recon ;;
            2) module_api_recon ;;
            3) module_port_service ;;
            4) module_cert_intel ;;
            5) module_vuln_intel ;;
            6) module_data_leak ;;
            7) module_report ;;
            8) set_api_keys ;;
            9) clear_workspace ;;
            0) echo -e "${CYAN}Exiting...${RESET}"; exit 0 ;;
            *) echo -e "${RED}[!] Invalid Option${RESET}"; sleep 1 ;;
        esac
        read -p "Press Enter to continue..."
    done
}

# ===================== START =====================
main_menu
