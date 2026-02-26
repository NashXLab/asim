#!/bin/bash
############################################################
# ASIM Operation Guide
# Interactive Script explaining how ASIM works
# For NASH LAB & Aven elite duo
############################################################

CYAN="\e[96m"; GREEN="\e[92m"; YELLOW="\e[93m"; RED="\e[91m"; RESET="\e[0m"

banner() {
    clear
    echo -e "${CYAN}"
    echo "    █████╗ ███████╗██╗███████╗"
    echo "   ██╔══██╗██╔════╝██║██╔════╝"
    echo "   ███████║███████╗██║█████╗  "
    echo "   ██╔══██║╚════██║██║██╔══╝  "
    echo "   ██║  ██║███████║██║███████╗"
    echo "   ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝"
    echo "   Attack Surface Intelligence Module"
    echo -e "${RESET}"
}

intro() {
    banner
    echo -e "${GREEN}Welcome to ASIM Guide Script${RESET}"
    echo -e "${YELLOW}This guide will explain how ASIM operates and how to use it.${RESET}"
    echo
    read -p "Press Enter to continue..."
}

guide_menu() {
    while true; do
        clear
        echo -e "${CYAN}==== ASIM OPERATION GUIDE ====${RESET}"
        echo -e "${YELLOW}1.${RESET} Overview of ASIM"
        echo -e "${YELLOW}2.${RESET} Workspace & Configuration"
        echo -e "${YELLOW}3.${RESET} Modules Explained"
        echo -e "${YELLOW}4.${RESET} How to Use ASIM"
        echo -e "${YELLOW}5.${RESET} Tips & Best Practices"
        echo -e "${YELLOW}0.${RESET} Exit Guide"
        read -p "Select an option: " choice
        case $choice in
            1) overview ;;
            2) workspace_config ;;
            3) modules_explained ;;
            4) usage ;;
            5) tips ;;
            0) echo -e "${CYAN}Exiting Guide...${RESET}"; break ;;
            *) echo -e "${RED}[!] Invalid option${RESET}"; sleep 1 ;;
        esac
        read -p "Press Enter to return to menu..."
    done
}

overview() {
    clear
    echo -e "${GREEN}ASIM Overview:${RESET}"
    echo "- ASIM is a fully integrated Attack Surface Intelligence Module."
    echo "- Menu-driven, interactive, and execution-first."
    echo "- Combines multiple modules: Passive Recon, API Recon, Port/Service Scan, Certificate Intelligence, Vulnerability Intelligence, Data Leak Monitoring, and Report Generation."
    echo "- Fully independent: no third-party scaffolds required."
}

workspace_config() {
    clear
    echo -e "${GREEN}Workspace & Configuration:${RESET}"
    echo "- Workspace directory: ~/nashlab_workspace"
    echo "- API keys stored in: ~/.nashlab/config.json"
    echo "- Each target has its own folder with outputs: subdomains, ports, API results, certificates, CVE info, leaks, and reports."
    echo "- Progress bars indicate module execution progress."
}

modules_explained() {
    clear
    echo -e "${GREEN}Modules Explained:${RESET}"
    echo "- ${YELLOW}1. Passive Recon:${RESET} Collects subdomains using Amass & Subfinder."
    echo "- ${YELLOW}2. Multi-Engine API Recon:${RESET} Queries Shodan, Censys, ZoomEye, and LeakIX for target info."
    echo "- ${YELLOW}3. Port & Service Analysis:${RESET} Scans top 100 ports and service versions using Nmap."
    echo "- ${YELLOW}4. Certificate Intelligence:${RESET} Fetches TLS/SSL certificates for a domain."
    echo "- ${YELLOW}5. Vulnerability Intelligence:${RESET} Checks software versions against CVEs (placeholder or live NVD API)."
    echo "- ${YELLOW}6. Data Leak Monitoring:${RESET} Monitors leaks related to a target domain/IP."
    echo "- ${YELLOW}7. Report Generation:${RESET} Creates a Markdown report summarizing all findings."
}

usage() {
    clear
    echo -e "${GREEN}How to Use ASIM:${RESET}"
    echo "1. Run ASIM script: ./asim.sh"
    echo "2. Use arrow keys or number selection to navigate the menu."
    echo "3. Set API keys before using multi-engine recon."
    echo "4. Select a module to execute; results are automatically saved in the workspace."
    echo "5. Generate a report to summarize findings."
    echo "6. Use 'Clear Workspace' if you want to remove all previous outputs."
}

tips() {
    clear
    echo -e "${GREEN}Tips & Best Practices:${RESET}"
    echo "- Always set API keys first for full functionality."
    echo "- Use passive recon before API recon for better efficiency."
    echo "- Review reports to track changes over time."
    echo "- Do not modify workspace folders manually; ASIM handles structure."
    echo "- Always run ASIM from the same environment to maintain path consistency."
}

# ===================== START GUIDE =====================
intro
guide_menu
