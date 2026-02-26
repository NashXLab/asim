# ASIM - Attack Surface Intelligence Module

**Elite Duo:** NASH LAB & Aven  
**Status:** Fully Independent | Self-Contained | Execution-Only  

---

## Overview

ASIM is a **menu-driven, all-in-one framework** for attack surface intelligence and reconnaissance. It integrates multiple modules to provide a **comprehensive view of a target**, including passive recon, API recon, port scanning, certificate intelligence, vulnerability checks, and data leak monitoring.

It is fully independent, requiring **no third-party scaffolds**, and stores all output in a **structured workspace**.

---

## Workspace & Configuration

- **Workspace directory:** `~/nashlab_workspace`  
- **API keys configuration:** `~/.nashlab/config.json`  
- **Target directories:** Each target gets its own folder with outputs:
  - `subdomains.txt` – Passive recon results  
  - `api_results.json` – Multi-engine API recon (Shodan, Censys, ZoomEye, LeakIX)  
  - `ports.txt` – Port & service scan results  
  - `certs.json` – TLS/SSL certificates  
  - `cve.json` – Vulnerability lookup results  
  - `leaks.json` – Data leak monitoring  
  - `final_report.md` – Summarized report

---

## Installation & Setup
*clone respiratory 
_ git clone 

- chmod +x *
- ./setup.sh
- ./asim.sh
    or
- pip install -r requirements.txt
- chmod +x *
- ./asim.sh or bash asim.sh

## How to Use ASIM
Run ASIM:

* bash asim.sh
*Navigate the menu using numbers.
*Set API keys before using multi-engine recon.
*Select a module to execute; results are automatically saved in the workspace.
*Generate a report to summarize all findings.
*Use 'Clear Workspace' if you want to remove all previous outputs.

###Modules
Module
Description
Passive Recon
Uses Amass & Subfinder to collect subdomains for a target.
Multi-Engine API Recon
Queries Shodan, Censys, ZoomEye, and LeakIX for target information.
Port & Service Analysis
Scans top 100 ports and service versions using Nmap.
Certificate Intelligence
Fetches TLS/SSL certificates for a domain.
Vulnerability Intelligence
Checks software versions against CVEs (NVD API placeholder).
Data Leak Monitoring
Monitors leaks related to a target domain/IP.
Report Generation
Creates a Markdown report summarizing all findings.

### 1. System Requirements
Tested and working on
- Python 3  
- Bash shell  
- Ubuntu/Debian system   or
- Termux(ubuntu-proot)

##Contact
Creator: NashXLab
Assistant/Partner: Aven
Workspace: ~/nashlab_workspace

### 2. Prerequisites

**System tools:**

```text
amass, subfinder, nmap, trufflehog, theharvester, jq, curl, wget, git
