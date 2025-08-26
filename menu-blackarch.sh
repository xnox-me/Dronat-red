#!/bin/bash

# Interactive menu for the Dronat BlackArch penetration testing environment
# Enhanced with security tools and penetration testing capabilities

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
    echo -e "  🐧 OS: BlackArch Linux ($(uname -r))"
    echo -e "  🖥️  CPU: $(nproc) cores"
    echo -e "  💾 Memory: $(free -h | awk '/^Mem:/ {print $2}') total"
    echo -e "  🐍 Python: $(python3 --version 2>/dev/null || echo 'Not available')"
    echo -e "  📦 Node.js: $(node --version 2>/dev/null || echo 'Not available')"
    echo -e "  📝 Neovim: $(nvim --version | head -1 | cut -d' ' -f2 2>/dev/null || echo 'Not available')"
    echo -e "  🔒 BlackArch: $(pacman -Q blackarch-keyring 2>/dev/null | cut -d' ' -f2 || echo 'Not available')"
    echo ""
}

# Check service status
check_services() {
    echo -e "${PURPLE}🔍 Service Status:${NC}"
    
    # Check for running services
    services=("n8n:5678" "jupyter:8888" "tensorboard:6006" "gradio:7860" "streamlit:8501" "mlflow:5000")
    for service in "${services[@]}"; do
        name=$(echo $service | cut -d':' -f1)
        port=$(echo $service | cut -d':' -f2)
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            echo -e "  ✅ $name running on port $port"
        else
            echo -e "  ⭕ $name not running"
        fi
    done
    
    # Check Shellngn Pro Docker container
    if docker ps 2>/dev/null | grep -q "shellngn"; then
        echo -e "  ✅ Shellngn Pro container running"
    else
        echo -e "  ⭕ Shellngn Pro container not running"
    fi
    echo ""
}

# Security tools status
check_security_tools() {
    echo -e "${RED}🛡️  Security Tools Status:${NC}"
    
    # Check for key security tools
    tools=("nmap" "masscan" "gobuster" "sqlmap" "burpsuite" "metasploit" "aircrack-ng" "hashcat" "john" "hydra")
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo -e "  ✅ $tool available"
        else
            echo -e "  ⭕ $tool not found"
        fi
    done
    echo ""
}

# --- Functions ---
show_menu() {
    clear
    echo -e "${BOLD}${RED}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}    🔒 Dronat BlackArch - Penetration Testing Environment    ${NC}"
    echo -e "${BOLD}${RED}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    get_system_info
    check_services
    check_security_tools
    
    echo -e "${BOLD}${GREEN}📋 Available Options:${NC}"
    echo -e "  ${YELLOW}1.${NC} 📝 Start Neovim (Enhanced Security IDE)"
    echo -e "  ${YELLOW}2.${NC} 🔄 Start n8n Workflow Editor"
    echo -e "  ${YELLOW}3.${NC} 💻 Open a Bash Shell"
    echo -e "  ${YELLOW}4.${NC} 🔍 Network Reconnaissance Tools"
    echo -e "  ${YELLOW}5.${NC} 🌐 Web Application Security Testing"
    echo -e "  ${YELLOW}6.${NC} 🔓 Password & Hash Cracking Tools"
    echo -e "  ${YELLOW}7.${NC} 📡 Wireless Security Testing"
    echo -e "  ${YELLOW}8.${NC} 🕷️  Exploit Development & Binary Analysis"
    echo -e "  ${YELLOW}9.${NC} 🧠 ML/AI Security Research Environment"
    echo -e "  ${YELLOW}10.${NC} 🌐 Start Shellngn Pro (Remote Access)"
    echo -e "  ${YELLOW}11.${NC} 🔧 System Tools & Utilities"
    echo -e "  ${YELLOW}12.${NC} 📚 Help & Documentation"
    echo -e "  ${YELLOW}13.${NC} 🚪 Exit"
    echo -e "${BOLD}${RED}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

start_neovim() {
    clear
    echo "Starting Neovim Security IDE..."
    nvim
}

start_n8n() {
    clear
    echo "Starting n8n workflow automation..."
    echo "You can access the n8n editor at http://localhost:5678"
    echo "Press Ctrl+C to stop n8n."
    n8n
}

open_shell() {
    clear
    echo "Starting Bash shell with security tools..."
    bash
}

network_reconnaissance() {
    clear
    echo -e "${BOLD}${RED}🔍 Network Reconnaissance Tools${NC}"
    echo "================================="
    echo ""
    echo "Choose your reconnaissance tool:"
    echo "1. Nmap (Network Scanner)"
    echo "2. Masscan (Fast Port Scanner)"
    echo "3. Gobuster (Directory/File Brute-forcer)"
    echo "4. DNSrecon (DNS Enumeration)"
    echo "5. TheHarvester (Email/Domain Gathering)"
    echo "6. Recon-ng (Reconnaissance Framework)"
    echo "7. Return to main menu"
    echo ""
    read -p "Enter your choice [1-7]: " recon_choice
    
    case $recon_choice in
        1)
            echo "🗺️  Starting Nmap..."
            echo "Example: nmap -sS -sV -O target_ip"
            echo "Usage: nmap [options] target"
            nmap
            ;;
        2)
            echo "⚡ Starting Masscan..."
            echo "Example: masscan -p1-65535 target_ip --rate=1000"
            echo "Usage: masscan [options] target"
            masscan
            ;;
        3)
            echo "📂 Starting Gobuster..."
            echo "Example: gobuster dir -u http://target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt"
            gobuster
            ;;
        4)
            echo "🌐 Starting DNSrecon..."
            echo "Example: dnsrecon -d target.com"
            dnsrecon -h || echo "DNSrecon not found. Install with: pip install dnsrecon"
            ;;
        5)
            echo "📧 Starting TheHarvester..."
            echo "Example: theharvester -d target.com -b google"
            theharvester || echo "TheHarvester not found"
            ;;
        6)
            echo "🔍 Starting Recon-ng..."
            echo "Framework for web reconnaissance"
            recon-ng || echo "Recon-ng not found"
            ;;
        7)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to reconnaissance menu..."
    read -r
    network_reconnaissance
}

web_security_testing() {
    clear
    echo -e "${BOLD}${GREEN}🌐 Web Application Security Testing${NC}"
    echo "===================================="
    echo ""
    echo "Choose your web security tool:"
    echo "1. Burp Suite (Web Proxy & Scanner)"
    echo "2. SQLmap (SQL Injection Testing)"
    echo "3. Nikto (Web Server Scanner)"
    echo "4. Dirb (Web Directory Scanner)"
    echo "5. OWASP ZAP (Web App Scanner)"
    echo "6. Wfuzz (Web Fuzzer)"
    echo "7. Return to main menu"
    echo ""
    read -p "Enter your choice [1-7]: " web_choice
    
    case $web_choice in
        1)
            echo "🔍 Starting Burp Suite..."
            echo "Professional web application security testing platform"
            burpsuite || echo "Burp Suite not found"
            ;;
        2)
            echo "💉 Starting SQLmap..."
            echo "Example: sqlmap -u 'http://target/page.php?id=1' --batch"
            sqlmap || echo "SQLmap not found"
            ;;
        3)
            echo "🔎 Starting Nikto..."
            echo "Example: nikto -h http://target"
            nikto || echo "Nikto not found"
            ;;
        4)
            echo "📁 Starting Dirb..."
            echo "Example: dirb http://target"
            dirb || echo "Dirb not found"
            ;;
        5)
            echo "🕷️  Starting OWASP ZAP..."
            echo "Web application security scanner"
            zaproxy || zap.sh || echo "OWASP ZAP not found"
            ;;
        6)
            echo "🔧 Starting Wfuzz..."
            echo "Example: wfuzz -c -z file,wordlist.txt http://target/FUZZ"
            wfuzz || echo "Wfuzz not found. Install with: pip install wfuzz"
            ;;
        7)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to web security menu..."
    read -r
    web_security_testing
}

password_cracking() {
    clear
    echo -e "${BOLD}${YELLOW}🔓 Password & Hash Cracking Tools${NC}"
    echo "=================================="
    echo ""
    echo "Choose your cracking tool:"
    echo "1. John the Ripper (Password Cracker)"
    echo "2. Hashcat (Advanced Password Recovery)"
    echo "3. Hydra (Network Login Cracker)"
    echo "4. Medusa (Parallel Login Brute-forcer)"
    echo "5. CrackMapExec (Post-exploitation Tool)"
    echo "6. Return to main menu"
    echo ""
    read -p "Enter your choice [1-6]: " crack_choice
    
    case $crack_choice in
        1)
            echo "🔨 Starting John the Ripper..."
            echo "Example: john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt"
            john || echo "John the Ripper not found"
            ;;
        2)
            echo "⚡ Starting Hashcat..."
            echo "Example: hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt"
            hashcat || echo "Hashcat not found"
            ;;
        3)
            echo "💧 Starting Hydra..."
            echo "Example: hydra -l admin -P passwords.txt ssh://target"
            hydra || echo "Hydra not found"
            ;;
        4)
            echo "🐙 Starting Medusa..."
            echo "Example: medusa -h target -u admin -P passwords.txt -M ssh"
            medusa || echo "Medusa not found"
            ;;
        5)
            echo "🗺️  Starting CrackMapExec..."
            echo "Example: crackmapexec smb target -u users.txt -p passwords.txt"
            crackmapexec || cme || echo "CrackMapExec not found"
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to password cracking menu..."
    read -r
    password_cracking
}

wireless_security() {
    clear
    echo -e "${BOLD}${BLUE}📡 Wireless Security Testing${NC}"
    echo "============================="
    echo ""
    echo "Choose your wireless tool:"
    echo "1. Aircrack-ng (WiFi Security Auditing)"
    echo "2. Kismet (Wireless Network Detector)"
    echo "3. Wifite (Automated WiFi Cracking)"
    echo "4. Reaver (WPS Cracking)"
    echo "5. Bettercap (Network Attack Framework)"
    echo "6. Return to main menu"
    echo ""
    read -p "Enter your choice [1-6]: " wireless_choice
    
    case $wireless_choice in
        1)
            echo "📡 Starting Aircrack-ng suite..."
            echo "Example: airodump-ng wlan0mon"
            aircrack-ng || echo "Aircrack-ng not found"
            ;;
        2)
            echo "👁️  Starting Kismet..."
            echo "Wireless network detector and packet sniffer"
            kismet || echo "Kismet not found"
            ;;
        3)
            echo "⚡ Starting Wifite..."
            echo "Automated WiFi cracking tool"
            wifite || echo "Wifite not found"
            ;;
        4)
            echo "🔓 Starting Reaver..."
            echo "WPS cracking tool"
            reaver || echo "Reaver not found"
            ;;
        5)
            echo "🕸️  Starting Bettercap..."
            echo "Network attack and monitoring framework"
            bettercap || echo "Bettercap not found"
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to wireless security menu..."
    read -r
    wireless_security
}

exploit_development() {
    clear
    echo -e "${BOLD}${PURPLE}🕷️  Exploit Development & Binary Analysis${NC}"
    echo "=========================================="
    echo ""
    echo "Choose your tool:"
    echo "1. Metasploit Framework"
    echo "2. GDB with GEF/PEDA"
    echo "3. Radare2 (Reverse Engineering)"
    echo "4. Binary Ninja (Free Version)"
    echo "5. Ropper (ROP Gadget Finder)"
    echo "6. Python Exploit Development Environment"
    echo "7. Return to main menu"
    echo ""
    read -p "Enter your choice [1-7]: " exploit_choice
    
    case $exploit_choice in
        1)
            echo "💥 Starting Metasploit Framework..."
            echo "Example: msfconsole"
            msfconsole || echo "Metasploit not found"
            ;;
        2)
            echo "🐛 Starting GDB..."
            echo "Enhanced with security plugins"
            gdb || echo "GDB not found"
            ;;
        3)
            echo "🔍 Starting Radare2..."
            echo "Reverse engineering framework"
            r2 || radare2 || echo "Radare2 not found"
            ;;
        4)
            echo "🧠 Binary Ninja (Free) would be available with proper installation"
            echo "Visit: https://binary.ninja/"
            ;;
        5)
            echo "🔗 Starting Ropper..."
            echo "ROP gadget finder"
            python3 -c "import ropper; print('Ropper available')" 2>/dev/null || echo "Ropper not found. Install with: pip install ropper"
            ;;
        6)
            echo "🐍 Starting Python exploit development environment..."
            echo "Available libraries: pwntools, capstone, keystone, unicorn"
            python3 -c "
import sys
print('🕷️  Exploit Development Python Environment')
print('Available libraries:')
try:
    import pwn
    print('  ✓ pwntools for exploit development')
except: print('  ✗ pwntools not available')
try:
    import capstone
    print('  ✓ Capstone disassembly engine')
except: print('  ✗ Capstone not available')
try:
    import keystone
    print('  ✓ Keystone assembler engine')
except: print('  ✗ Keystone not available')
try:
    import unicorn
    print('  ✓ Unicorn CPU emulator')
except: print('  ✗ Unicorn not available')
print('\n💡 Example: from pwn import *')
import IPython
IPython.embed()
"
            ;;
        7)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to exploit development menu..."
    read -r
    exploit_development
}

start_ml_ai_security() {
    clear
    echo "🤖 ML/AI Security Research Environment"
    echo "======================================"
    echo ""
    echo "Choose your ML/AI security tool:"
    echo "1. JupyterLab (Security Data Analysis)"
    echo "2. TensorFlow Security Models"
    echo "3. Adversarial ML Research Environment"
    echo "4. Network Traffic Analysis with ML"
    echo "5. Malware Analysis with AI"
    echo "6. Return to main menu"
    echo ""
    read -p "Enter your choice [1-6]: " ml_choice
    
    case $ml_choice in
        1)
            echo "🚀 Starting JupyterLab for security research..."
            echo "Access at: http://localhost:8888"
            jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
            ;;
        2)
            echo "🧠 TensorFlow Security Research Environment..."
            python3 -c "
import tensorflow as tf
import numpy as np
import pandas as pd
print('🤖 TensorFlow Security Research Environment')
print(f'TensorFlow version: {tf.__version__}')
print('Available for: Intrusion detection, malware classification, anomaly detection')
import IPython
IPython.embed()
"
            ;;
        3)
            echo "⚔️  Adversarial ML Research..."
            python3 -c "
import numpy as np
try:
    import tensorflow as tf
    print('🎯 Adversarial ML Research Environment')
    print('Available for: Adversarial attacks, model robustness testing')
    print('Libraries: TensorFlow, NumPy for creating adversarial examples')
except ImportError:
    print('TensorFlow not available for adversarial research')
import IPython
IPython.embed()
"
            ;;
        4)
            echo "📊 Network Traffic Analysis with ML..."
            python3 -c "
import pandas as pd
import numpy as np
try:
    import scapy
    print('📡 Network Traffic ML Analysis Environment')
    print('Available: Scapy for packet capture, ML for traffic classification')
except ImportError:
    print('Scapy not available for network analysis')
import IPython
IPython.embed()
"
            ;;
        5)
            echo "🦠 Malware Analysis with AI..."
            python3 -c "
import numpy as np
import pandas as pd
print('🦠 Malware Analysis AI Environment')
print('Available for: Static/dynamic analysis, feature extraction, classification')
print('Use with: PE file analysis, behavioral analysis')
import IPython
IPython.embed()
"
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to ML/AI security menu..."
    read -r
    start_ml_ai_security
}

start_shellngn() {
    clear
    echo "Starting Shellngn Pro (SSH/SFTP/VNC/RDP Web Client)..."
    echo "======================================================"
    echo ""
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not available. Shellngn Pro requires Docker to run."
        sleep 3
        return
    fi
    
    # Check if Shellngn container is already running
    if docker ps | grep -q "shellngn"; then
        echo "ℹ️  Shellngn Pro is already running!"
        echo "   Access it at: http://localhost:8080"
    else
        echo "🚀 Starting Shellngn Pro container..."
        docker pull shellngn/pro
        docker run -d --name shellngn -p 8080:8080 -v "$(pwd)/shellngn-data:/data" shellngn/pro
        
        if [ $? -eq 0 ]; then
            echo "✅ Shellngn Pro started successfully!"
            echo "🌐 Access Shellngn Pro at: http://localhost:8080"
        else
            echo "❌ Failed to start Shellngn Pro container."
        fi
    fi
    
    echo ""
    echo "Press Enter to return to main menu..."
    read -r
}

system_tools() {
    clear
    echo "🔧 System Tools & Utilities"
    echo "==========================="
    echo ""
    echo "1. System Information"
    echo "2. Process Monitor (htop)"
    echo "3. Network Connections"
    echo "4. Disk Usage"
    echo "5. Update BlackArch Packages"
    echo "6. Return to main menu"
    echo ""
    read -p "Enter your choice [1-6]: " sys_choice
    
    case $sys_choice in
        1)
            echo "📊 System Information:"
            uname -a
            lscpu | head -20
            free -h
            ;;
        2)
            echo "📈 Starting Process Monitor..."
            htop || top
            ;;
        3)
            echo "🌐 Network Connections:"
            netstat -tuln
            ;;
        4)
            echo "💾 Disk Usage:"
            df -h
            ;;
        5)
            echo "📦 Updating BlackArch packages..."
            sudo pacman -Syu
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid choice"
            sleep 2
            ;;
    esac
    
    echo ""
    echo "Press Enter to continue..."
    read -r
    system_tools
}

show_help() {
    clear
    echo -e "${BOLD}${CYAN}📚 Dronat BlackArch Help & Documentation${NC}"
    echo "========================================"
    echo ""
    echo -e "${YELLOW}🔒 Security Tools:${NC}"
    echo "  • Network Recon: nmap, masscan, gobuster"
    echo "  • Web Security: burpsuite, sqlmap, nikto"
    echo "  • Password Cracking: john, hashcat, hydra"
    echo "  • Wireless: aircrack-ng, kismet, wifite"
    echo "  • Exploit Dev: metasploit, gdb, radare2"
    echo ""
    echo -e "${YELLOW}🐍 Python Security Libraries:${NC}"
    echo "  • scapy - Packet manipulation"
    echo "  • pwntools - Exploit development"
    echo "  • impacket - Network protocols"
    echo "  • cryptography - Cryptographic recipes"
    echo ""
    echo -e "${YELLOW}🧠 ML/AI Security:${NC}"
    echo "  • TensorFlow/PyTorch for ML models"
    echo "  • Anomaly detection algorithms"
    echo "  • Adversarial ML research"
    echo "  • Network traffic analysis"
    echo ""
    echo -e "${YELLOW}📁 Important Directories:${NC}"
    echo "  • /home/devuser/pentest - Your pentest workspace"
    echo "  • /home/devuser/wordlists - Custom wordlists"
    echo "  • /home/devuser/exploits - Exploit code"
    echo "  • /usr/share/wordlists - System wordlists"
    echo ""
    echo "Press Enter to return to main menu..."
    read -r
}

# Main menu loop
while true; do
    show_menu
    read -p "Choose an option [1-13]: " choice
    
    case $choice in
        1) start_neovim ;;
        2) start_n8n ;;
        3) open_shell ;;
        4) network_reconnaissance ;;
        5) web_security_testing ;;
        6) password_cracking ;;
        7) wireless_security ;;
        8) exploit_development ;;
        9) start_ml_ai_security ;;
        10) start_shellngn ;;
        11) system_tools ;;
        12) show_help ;;
        13) 
            echo -e "${GREEN}🔒 Thank you for using Dronat BlackArch! Stay ethical! 🔒${NC}"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select 1-13."
            sleep 2
            ;;
    esac
done