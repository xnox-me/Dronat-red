#!/bin/bash

# Interactive menu for the Dronat Red team operations environment
# Enhanced with offensive security tools and red team capabilities

# Color codes for enhanced UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# System information
get_system_info() {
    echo -e "${CYAN}📊 System Information:${NC}"
    echo -e "  🐧 OS: Ubuntu 24.04 LTS ($(uname -r))"
    echo -e "  🖥️  CPU: $(nproc) cores"
    echo -e "  💾 Memory: $(free -h | awk '/^Mem:/ {print $2}') total"
    echo -e "  🐍 Python: $(python3 --version 2>/dev/null || echo 'Not available')"
    echo -e "  📦 Node.js: $(node --version 2>/dev/null || echo 'Not available')"
    echo -e "  🔴 Dronat Red: Active"
    echo ""
}

# Check red team tools status
check_redteam_tools() {
    echo -e "${RED}🚩 Red Team Tools Status:${NC}"
    
    tools=("nmap" "metasploit" "hydra" "john" "hashcat" "sqlmap" "gobuster" "nikto")
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo -e "  ✅ $tool available"
        else
            echo -e "  ⭕ $tool not found"
        fi
    done
    echo ""
}

# Main menu
show_menu() {
    clear
    echo -e "${BOLD}${RED}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}       🚩 Dronat Red - Red Team Operations Environment       ${NC}"
    echo -e "${BOLD}${RED}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    get_system_info
    check_redteam_tools
    
    echo -e "${BOLD}${GREEN}📋 Red Team Operations:${NC}"
    echo -e "  ${YELLOW}1.${NC} 📝 Start Neovim (Red Team IDE)"
    echo -e "  ${YELLOW}2.${NC} 🔄 Start n8n Workflow Editor"
    echo -e "  ${YELLOW}3.${NC} 💻 Open a Bash Shell"
    echo -e "  ${YELLOW}4.${NC} 🔍 Reconnaissance & Intelligence"
    echo -e "  ${YELLOW}5.${NC} 🎯 Initial Access & Exploitation"
    echo -e "  ${YELLOW}6.${NC} 🔐 Credential Access & PrivEsc"
    echo -e "  ${YELLOW}7.${NC} 🌐 Command & Control (C2)"
    echo -e "  ${YELLOW}8.${NC} 🕵️ Persistence & Lateral Movement"
    echo -e "  ${YELLOW}9.${NC} 📡 Collection & Exfiltration"
    echo -e "  ${YELLOW}10.${NC} 🎭 Social Engineering"
    echo -e "  ${YELLOW}11.${NC} 🧠 ML/AI Offensive Security"
    echo -e "  ${YELLOW}12.${NC} 🌐 Start Shellngn Pro"
    echo -e "  ${YELLOW}13.${NC} 🔧 Red Team Utilities"
    echo -e "  ${YELLOW}14.${NC} 📚 Help & Documentation"
    echo -e "  ${YELLOW}15.${NC} 🚪 Exit"
    echo -e "${BOLD}${RED}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${RED}⚠️  WARNING: For authorized testing and educational use only!${NC}"
    echo ""
}

start_neovim() {
    clear
    echo "Starting Neovim Red Team IDE..."
    nvim
}

start_n8n() {
    clear
    echo "Starting n8n workflow automation for red team operations..."
    echo "Access at http://localhost:5678"
    n8n
}

open_shell() {
    clear
    echo "Starting Red Team shell with offensive security tools..."
    bash
}

reconnaissance() {
    clear
    echo -e "${BOLD}${BLUE}🔍 Reconnaissance & Intelligence Gathering${NC}"
    echo "==========================================="
    echo ""
    echo "1. Network Discovery (nmap, masscan)"
    echo "2. Web Application Recon (gobuster, nikto)"
    echo "3. DNS Enumeration (dig, fierce)"
    echo "4. OSINT & Information Gathering"
    echo "5. Vulnerability Scanning"
    echo "6. Return to main menu"
    echo ""
    read -p "Enter your choice [1-6]: " recon_choice
    
    case $recon_choice in
        1)
            echo "🗺️  Network Discovery"
            echo "Commands: nmap -sn <network>, nmap -sS -sV <target>"
            nmap
            ;;
        2)
            echo "🌐 Web Application Reconnaissance"
            echo "Commands: gobuster dir -u <url> -w wordlist, nikto -h <target>"
            read -p "Enter target URL: " url
            if [ -n "$url" ]; then
                gobuster dir -u "$url" -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
            fi
            ;;
        3)
            echo "🌐 DNS Enumeration"
            echo "Commands: dig <domain> any, fierce -dns <domain>"
            read -p "Enter domain: " domain
            if [ -n "$domain" ]; then
                dig "$domain" any
            fi
            ;;
        4)
            echo "🕵️ OSINT & Information Gathering"
            python3 -c "
print('🔍 OSINT Environment')
print('Available: requests, beautifulsoup4, shodan, censys')
import IPython
IPython.embed()
"
            ;;
        5)
            echo "🛡️ Vulnerability Scanning"
            echo "Commands: nmap --script vuln <target>"
            read -p "Enter target: " target
            if [ -n "$target" ]; then
                nmap --script vuln "$target"
            fi
            ;;
        6) return ;;
    esac
    
    read -p "Press Enter to continue..."
    reconnaissance
}

initial_access() {
    clear
    echo -e "${BOLD}${RED}🎯 Initial Access & Exploitation${NC}"
    echo "================================="
    echo ""
    echo "1. Web Application Exploitation (SQLMap)"
    echo "2. Network Service Exploitation"
    echo "3. Password Attacks (Hydra, John)"
    echo "4. Metasploit Framework"
    echo "5. Custom Exploit Development"
    echo "6. Return to main menu"
    echo ""
    read -p "Enter your choice [1-6]: " access_choice
    
    case $access_choice in
        1)
            echo "💉 Web Application Exploitation"
            read -p "Enter target URL: " url
            if [ -n "$url" ]; then
                sqlmap -u "$url" --batch --random-agent
            else
                sqlmap
            fi
            ;;
        2)
            echo "🔌 Network Service Exploitation"
            python3 -c "
print('🔌 Network Exploitation Environment')
try:
    from pwn import *
    print('✓ pwntools available')
    context.arch = 'amd64'
    context.os = 'linux'
except ImportError:
    print('✗ pwntools not available')
import IPython
IPython.embed()
"
            ;;
        3)
            echo "🔐 Password Attacks"
            echo "Choose: 1) Hydra 2) John 3) Hashcat"
            read -p "Choice: " pass_choice
            case $pass_choice in
                1) hydra ;;
                2) john ;;
                3) hashcat ;;
            esac
            ;;
        4)
            echo "💥 Metasploit Framework"
            sudo msfconsole
            ;;
        5)
            echo "🛠️ Custom Exploit Development"
            python3 -c "
print('🛠️ Exploit Development Environment')
try:
    import pwn, capstone, keystone, unicorn
    print('✓ All exploit dev libraries available')
except ImportError as e:
    print(f'✗ Some libraries missing: {e}')
import IPython
IPython.embed()
"
            ;;
        6) return ;;
    esac
    
    read -p "Press Enter to continue..."
    initial_access
}

credential_access() {
    clear
    echo -e "${BOLD}${YELLOW}🔐 Credential Access & Privilege Escalation${NC}"
    echo "============================================"
    echo ""
    echo "1. Hash Dumping & Cracking"
    echo "2. Kerberos Attacks"
    echo "3. LLMNR/NBT-NS Poisoning"
    echo "4. Privilege Escalation Enumeration"
    echo "5. Return to main menu"
    echo ""
    read -p "Enter your choice [1-5]: " cred_choice
    
    case $cred_choice in
        1)
            echo "🔨 Hash Dumping & Cracking"
            python3 -c "
print('🔨 Hash Analysis Environment')
try:
    import impacket
    print('✓ Impacket available')
except ImportError:
    print('✗ Impacket not available')
print('Available: john, hashcat for cracking')
import IPython
IPython.embed()
"
            ;;
        2)
            echo "🎫 Kerberos Attacks"
            python3 -c "
print('🎫 Kerberos Attack Environment')
print('Techniques: SPN enumeration, AS-REP roasting')
import IPython
IPython.embed()
"
            ;;
        3)
            echo "☠️ LLMNR/NBT-NS Poisoning"
            if [ -d "/opt/Responder" ]; then
                sudo python3 /opt/Responder/Responder.py -h
            else
                echo "Responder not available"
            fi
            ;;
        4)
            echo "📈 Privilege Escalation"
            python3 -c "
print('📈 PrivEsc Enumeration')
import os
print('SUID files:')
os.system('find / -perm -4000 2>/dev/null | head -10')
import IPython
IPython.embed()
"
            ;;
        5) return ;;
    esac
    
    read -p "Press Enter to continue..."
    credential_access
}

command_control() {
    clear
    echo -e "${BOLD}${PURPLE}🌐 Command & Control (C2) Frameworks${NC}"
    echo "====================================="
    echo ""
    echo "1. Empire C2 Framework"
    echo "2. Metasploit Multi/Handler"
    echo "3. Custom C2 Development"
    echo "4. Return to main menu"
    echo ""
    read -p "Enter your choice [1-4]: " c2_choice
    
    case $c2_choice in
        1)
            if [ -d "/home/devuser/Empire" ]; then
                cd /home/devuser/Empire && sudo python3 empire --rest
            else
                echo "Empire not available"
            fi
            ;;
        2)
            echo "💥 Metasploit Handler"
            sudo msfconsole -x "use exploit/multi/handler; set payload windows/meterpreter/reverse_tcp; set LHOST 0.0.0.0; set LPORT 4444; exploit"
            ;;
        3)
            echo "🛠️ Custom C2 Development"
            python3 -c "
print('🛠️ Custom C2 Development')
print('Available: socket, threading, encryption')
import socket, threading, base64
print('Example: server = socket.socket()')
import IPython
IPython.embed()
"
            ;;
        4) return ;;
    esac
    
    read -p "Press Enter to continue..."
    command_control
}

persistence_lateral() {
    clear
    echo -e "${BOLD}${GREEN}🕵️ Persistence & Lateral Movement${NC}"
    echo "==================================="
    echo ""
    echo "1. Persistence Mechanisms"
    echo "2. Lateral Movement Techniques"
    echo "3. Active Directory Attacks"
    echo "4. Return to main menu"
    echo ""
    read -p "Enter your choice [1-4]: " persist_choice
    
    case $persist_choice in
        1)
            echo "🔗 Persistence Mechanisms"
            python3 -c "
print('🔗 Persistence Techniques')
print('Available methods:')
print('  • Cron jobs')
print('  • Service installation')
print('  • Registry modifications')
print('  • File system persistence')
import IPython
IPython.embed()
"
            ;;
        2)
            echo "🔄 Lateral Movement"
            python3 -c "
print('🔄 Lateral Movement Techniques')
print('Available tools: psexec, wmiexec, ssh')
try:
    import impacket
    print('✓ Impacket available for lateral movement')
except ImportError:
    print('✗ Impacket not available')
import IPython
IPython.embed()
"
            ;;
        3)
            echo "🏢 Active Directory Attacks"
            python3 -c "
print('🏢 Active Directory Attack Environment')
print('Techniques: DCSync, Golden Ticket, etc.')
import IPython
IPython.embed()
"
            ;;
        4) return ;;
    esac
    
    read -p "Press Enter to continue..."
    persistence_lateral
}

collection_exfiltration() {
    clear
    echo -e "${BOLD}${CYAN}📡 Collection & Exfiltration${NC}"
    echo "============================="
    echo ""
    echo "1. Data Collection Techniques"
    echo "2. Exfiltration Methods"
    echo "3. Steganography & Covert Channels"
    echo "4. Return to main menu"
    echo ""
    read -p "Enter your choice [1-4]: " collect_choice
    
    case $collect_choice in
        1)
            echo "📊 Data Collection"
            python3 -c "
print('📊 Data Collection Environment')
print('Techniques: File enumeration, database access, memory dumps')
import os, glob
print('Example file search:')
files = glob.glob('/home/*/*.txt')[:5]
for f in files:
    print(f'  {f}')
import IPython
IPython.embed()
"
            ;;
        2)
            echo "📤 Exfiltration Methods"
            python3 -c "
print('📤 Data Exfiltration Environment')
print('Methods: HTTP, DNS, email, cloud storage')
print('Available: requests, base64, encryption')
import requests, base64
import IPython
IPython.embed()
"
            ;;
        3)
            echo "🕵️ Steganography & Covert Channels"
            python3 -c "
print('🕵️ Steganography Environment')
try:
    import stegano
    print('✓ Stegano available')
except ImportError:
    print('✗ Stegano not available')
print('Available: PIL for image manipulation')
import IPython
IPython.embed()
"
            ;;
        4) return ;;
    esac
    
    read -p "Press Enter to continue..."
    collection_exfiltration
}

social_engineering() {
    clear
    echo -e "${BOLD}${YELLOW}🎭 Social Engineering & Phishing${NC}"
    echo "================================="
    echo ""
    echo "1. Phishing Campaign Development"
    echo "2. Social Engineering Toolkit (SET)"
    echo "3. Email Template Generation"
    echo "4. Return to main menu"
    echo ""
    read -p "Enter your choice [1-4]: " se_choice
    
    case $se_choice in
        1)
            echo "🎣 Phishing Campaign Development"
            python3 -c "
print('🎣 Phishing Campaign Environment')
print('Available: email templates, web cloning, payload delivery')
print('Tools: requests, beautifulsoup4, email libraries')
import requests, email
import IPython
IPython.embed()
"
            ;;
        2)
            echo "🛠️ Social Engineering Toolkit"
            if command -v setoolkit &>/dev/null; then
                sudo setoolkit
            else
                echo "SET not available"
            fi
            ;;
        3)
            echo "📧 Email Template Generation"
            python3 -c "
print('📧 Email Template Generator')
print('Creating phishing email templates...')
template = '''
Subject: Urgent Security Update Required

Dear [NAME],

Your account requires immediate attention...
[MALICIOUS_LINK]

Best regards,
IT Security Team
'''
print('Template example:')
print(template)
import IPython
IPython.embed()
"
            ;;
        4) return ;;
    esac
    
    read -p "Press Enter to continue..."
    social_engineering
}

ml_offensive_security() {
    clear
    echo -e "${BOLD}${BLUE}🧠 ML/AI Offensive Security Research${NC}"
    echo "===================================="
    echo ""
    echo "1. Adversarial ML Attacks"
    echo "2. AI-Powered Security Testing"
    echo "3. Machine Learning Evasion"
    echo "4. Return to main menu"
    echo ""
    read -p "Enter your choice [1-4]: " ml_choice
    
    case $ml_choice in
        1)
            echo "⚔️ Adversarial ML Attacks"
            python3 -c "
print('⚔️ Adversarial ML Environment')
try:
    import tensorflow as tf, numpy as np
    print('✓ TensorFlow available for adversarial attacks')
    print('Example: FGSM, PGD attacks on ML models')
except ImportError:
    print('✗ TensorFlow not available')
import IPython
IPython.embed()
"
            ;;
        2)
            echo "🤖 AI-Powered Security Testing"
            python3 -c "
print('🤖 AI-Powered Security Testing')
print('Using ML for automated vulnerability discovery')
print('Available: scikit-learn, pandas for analysis')
import IPython
IPython.embed()
"
            ;;
        3)
            echo "🕵️ ML Evasion Techniques"
            python3 -c "
print('🕵️ ML Evasion Research')
print('Techniques for evading ML-based security systems')
print('Available: feature manipulation, model poisoning')
import IPython
IPython.embed()
"
            ;;
        4) return ;;
    esac
    
    read -p "Press Enter to continue..."
    ml_offensive_security
}

start_shellngn() {
    clear
    echo "🌐 Starting Shellngn Pro for remote C2 access..."
    if command -v docker &>/dev/null; then
        docker run -d --name shellngn -p 8080:8080 -v "$(pwd)/shellngn-data:/data" shellngn/pro
        echo "✅ Shellngn Pro started at http://localhost:8080"
    else
        echo "❌ Docker not available"
    fi
    read -p "Press Enter to continue..."
}

redteam_utilities() {
    clear
    echo -e "${BOLD}${GREEN}🔧 Red Team Utilities & Tools${NC}"
    echo "============================="
    echo ""
    echo "1. Payload Generation"
    echo "2. Encoding & Obfuscation"
    echo "3. Network Utilities"
    echo "4. System Information"
    echo "5. Return to main menu"
    echo ""
    read -p "Enter your choice [1-5]: " util_choice
    
    case $util_choice in
        1)
            echo "💣 Payload Generation"
            python3 -c "
print('💣 Payload Generation Environment')
print('Available: shellcode generation, encoding, obfuscation')
import base64, binascii
shellcode = b'\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68'
print(f'Example shellcode: {shellcode.hex()}')
import IPython
IPython.embed()
"
            ;;
        2)
            echo "🔄 Encoding & Obfuscation"
            python3 -c "
print('🔄 Encoding & Obfuscation Tools')
import base64, binascii, zlib
text = 'malicious payload'
encoded = base64.b64encode(text.encode()).decode()
print(f'Base64: {encoded}')
import IPython
IPython.embed()
"
            ;;
        3)
            echo "🌐 Network Utilities"
            echo "Available: netcat, socat, hping3"
            netstat -tuln
            ;;
        4)
            echo "📊 System Information"
            uname -a
            lscpu | head -10
            free -h
            ;;
        5) return ;;
    esac
    
    read -p "Press Enter to continue..."
    redteam_utilities
}

show_help() {
    clear
    echo -e "${BOLD}${CYAN}📚 Dronat Red Help & Documentation${NC}"
    echo "=================================="
    echo ""
    echo -e "${YELLOW}🚩 Red Team Operations:${NC}"
    echo "  • Reconnaissance: nmap, gobuster, nikto"
    echo "  • Exploitation: metasploit, sqlmap, custom exploits"
    echo "  • Post-Exploitation: persistence, lateral movement"
    echo "  • C2 Frameworks: Empire, custom development"
    echo ""
    echo -e "${YELLOW}⚠️ Ethical Guidelines:${NC}"
    echo "  • Only test authorized systems"
    echo "  • Follow responsible disclosure"
    echo "  • Document all activities"
    echo "  • Respect legal boundaries"
    echo ""
    read -p "Press Enter to return to main menu..."
}

# Main menu loop
while true; do
    show_menu
    read -p "Choose an operation [1-15]: " choice
    
    case $choice in
        1) start_neovim ;;
        2) start_n8n ;;
        3) open_shell ;;
        4) reconnaissance ;;
        5) initial_access ;;
        6) credential_access ;;
        7) command_control ;;
        8) persistence_lateral ;;
        9) collection_exfiltration ;;
        10) social_engineering ;;
        11) ml_offensive_security ;;
        12) start_shellngn ;;
        13) redteam_utilities ;;
        14) show_help ;;
        15) 
            echo -e "${GREEN}🚩 Thank you for using Dronat Red! Stay ethical! 🚩${NC}"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select 1-15."
            sleep 2
            ;;
    esac
done