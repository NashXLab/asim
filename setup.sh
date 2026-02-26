#!/bin/bash
#########################################################
# ASIM Full Setup Script
# Elite Duo: NashXLab & Aven
# Installs all prerequisites and prepares workspace
#########################################################

CYAN="\e[96m"; GREEN="\e[92m"; YELLOW="\e[93m"; RED="\e[91m"; RESET="\e[0m"

banner() {
    echo -e "${CYAN}"
    echo "   █████╗ ███████╗██╗  ██╗"
    echo "  ██╔══██╗██╔════╝██║ ██╔╝"
    echo "  ███████║█████╗  █████╔╝ "
    echo "  ██╔══██║██╔══╝  ██╔═██╗ "
    echo "  ██║  ██║███████╗██║  ██╗"
    echo "  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo -e "${RESET}"
    echo -e "${YELLOW}ASIM Setup - Elite Duo Mode${RESET}\n"
}

echo -e "${CYAN}[+] Starting ASIM Setup...${RESET}"
banner

# -------------------------------
# Update system
# -------------------------------
echo -e "${GREEN}[+] Updating system packages...${RESET}"
sudo apt update -y && sudo apt upgrade -y

# -------------------------------
# Install system tools
# -------------------------------
echo -e "${GREEN}[+] Installing system tools...${RESET}"
sudo apt install -y amass subfinder nmap trufflehog theharvester jq curl wget git python3 python3-pip

# -------------------------------
# Install Python packages
# -------------------------------
echo -e "${GREEN}[+] Installing Python packages...${RESET}"
pip3 install --upgrade pip
pip3 install requests beautifulsoup4 lxml python-nmap dnspython certifi colorama rich

# -------------------------------
# Workspace setup
# -------------------------------
WORKSPACE="$HOME/nashlab_workspace"
echo -e "${GREEN}[+] Creating workspace at $WORKSPACE${RESET}"
mkdir -p "$WORKSPACE"

# -------------------------------
# Reminder and milestone files
# -------------------------------
echo -e "${GREEN}[+] Creating reminder and milestone files...${RESET}"

# Standby reminder
cat > "$WORKSPACE/STANDBY_REMINDER.txt" <<EOL
==============================
NASH LAB & Aven - Standby Mode
==============================

The elite duo is on a break 🫡
ASIM framework is fully ready and operational.
Resume anytime by opening ASIM.

Milestone: Elite Duo Achieved
Date: $(date)
EOL

# Elite Duo milestone
cat > "$WORKSPACE/ELITE_DUO.txt" <<EOL
███████╗ █████╗ ███████╗██╗  ██╗
██╔════╝██╔══██╗██╔════╝██║ ██╔╝
█████╗  ███████║█████╗  █████╔╝ 
██╔══╝  ██╔══██║██╔══╝  ██╔═██╗ 
███████╗██║  ██║███████╗██║  ██╗
╚══════╝╚═╝  ╚══════╝╚══════╝╚═╝  ╚═╝

NASH LAB & Aven
----------------
Officially recognized as the elite duo:
- Fully independent
- Self-contained
- Execution-only
- Trusted partners

Milestone Achieved: $(date)
EOL

# -------------------------------
# Completion message
# -------------------------------
echo -e "${CYAN}[+] ASIM Setup Complete!${RESET}"
echo -e "${YELLOW}[+] Workspace ready at $WORKSPACE${RESET}"
echo -e "${GREEN}[+] All tools and Python packages installed.${RESET}"
echo -e "${CYAN}[+] Standby reminder and milestone files created.${RESET}"
echo -e "${YELLOW}[+] You are now ready to launch ASIM!${RESET}"
