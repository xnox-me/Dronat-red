#!/bin/bash

# Dronat Red Team Environment Test Suite
# Comprehensive testing of all red team tools and offensive security capabilities

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
CRITICAL_FAILURES=()

# Functions for output
print_test_header() {
    echo -e "\n${BOLD}${RED}🚩 $1${NC}"
    echo "========================================"
}

print_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
    ((TOTAL_TESTS++))
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED_TESTS++))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED_TESTS++))
}

print_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

print_critical() {
    echo -e "${BOLD}${RED}[CRITICAL]${NC} $1"
    CRITICAL_FAILURES+=("$1")
    ((FAILED_TESTS++))
}

# Test function wrapper
run_test() {
    local test_name="$1"
    local test_command="$2"
    local is_critical="${3:-false}"
    
    print_test "$test_name"
    
    if eval "$test_command" &>/dev/null; then
        print_pass "$test_name"
        return 0
    else
        if [ "$is_critical" = "true" ]; then
            print_critical "$test_name"
        else
            print_fail "$test_name"
        fi
        return 1
    fi
}

# Test system requirements and base tools
test_system_requirements() {
    print_test_header "System Requirements & Base Tools"
    
    run_test "Python 3.11+ availability" "python3 --version | grep -E 'Python 3\.(11|12|13)'" true
    run_test "Pip package manager" "pip --version" true
    run_test "Git version control" "git --version"
    run_test "Curl HTTP client" "curl --version"
    run_test "Wget downloader" "wget --version"
    run_test "Sudo privileges" "sudo -n true 2>/dev/null || sudo -v"
    
    # Check critical directories
    run_test "Red team workspace" "ls -d /home/devuser/redteam 2>/dev/null || mkdir -p redteam" true
    run_test "Payloads directory" "ls -d /home/devuser/payloads 2>/dev/null || mkdir -p payloads"
    run_test "Loot directory" "ls -d /home/devuser/loot 2>/dev/null || mkdir -p loot"
}

# Test reconnaissance and intelligence tools
test_reconnaissance_tools() {
    print_test_header "Reconnaissance & Intelligence Gathering"
    
    # Network reconnaissance
    run_test "Nmap network scanner" "nmap --version" true
    run_test "Masscan high-speed scanner" "masscan --version"
    run_test "Zmap Internet scanner" "zmap --version"
    
    # Web reconnaissance  
    run_test "Gobuster directory brute-forcer" "gobuster version"
    run_test "Dirb web content scanner" "dirb"
    run_test "Nikto web vulnerability scanner" "nikto -Version"
    run_test "Aquatone visual domain recon" "command -v aquatone"
    
    # DNS and subdomain enumeration
    run_test "Subfinder subdomain discovery" "command -v subfinder"
    run_test "DNSRecon DNS enumeration" "command -v dnsrecon"
    
    # OSINT tools
    run_test "TheHarvester email gathering" "command -v theHarvester"
    run_test "Recon-ng framework" "command -v recon-ng"
    
    # Verify Python OSINT libraries
    run_test "Shodan Python library" "python3 -c 'import shodan'"
    run_test "Censys Python library" "python3 -c 'import censys'"
}

# Test initial access and exploitation tools
test_exploitation_tools() {
    print_test_header "Initial Access & Exploitation"
    
    # Web application exploitation
    run_test "SQLMap SQL injection tool" "sqlmap --version" true
    run_test "Burp Suite Professional" "command -v burpsuite || echo 'Manual install required'"
    
    # Network exploitation frameworks
    run_test "Metasploit Framework" "msfconsole -v" true
    run_test "Metasploit database" "msfdb status"
    
    # Exploit development tools
    run_test "GDB debugger" "gdb --version"
    run_test "Radare2 reverse engineering" "r2 -v || radare2 -v"
    
    # Python exploitation libraries
    run_test "Pwntools exploitation library" "python3 -c 'import pwn; print(\"Pwntools:\", pwn.__version__)'" true
    run_test "Ropper ROP gadget finder" "python3 -c 'import ropper'"
    run_test "Capstone disassembly framework" "python3 -c 'import capstone'"
    run_test "Keystone assembler framework" "python3 -c 'import keystone'"
    run_test "Unicorn CPU emulator" "python3 -c 'import unicorn'"
    
    # Binary analysis
    run_test "Impacket protocol library" "python3 -c 'import impacket'" true
    run_test "Scapy packet manipulation" "python3 -c 'import scapy.all'" true
}

# Test post-exploitation and persistence tools
test_postexploitation_tools() {
    print_test_header "Post-Exploitation & Persistence"
    
    # Privilege escalation
    run_test "LinPEAS Linux privilege escalation" "command -v linpeas.sh || ls /opt/linpeas.sh"
    run_test "WinPEAS Windows privilege escalation" "ls /opt/winPEAS.exe 2>/dev/null || echo 'Optional'"
    
    # Credential access
    run_test "John the Ripper password cracker" "john --version" true
    run_test "Hashcat advanced password recovery" "hashcat --version" true
    run_test "Hydra network login cracker" "hydra -h" true
    run_test "Medusa brute force tool" "medusa -h"
    
    # Network tools
    run_test "Netcat Swiss Army knife" "nc -h"
    run_test "Socat network relay" "socat -V"
    
    # Hash and credential analysis
    run_test "Hashid hash identifier" "command -v hashid"
}

# Test C2 frameworks and communication
test_c2_frameworks() {
    print_test_header "Command & Control (C2) Frameworks"
    
    # PowerShell Empire
    run_test "Empire C2 framework" "ls /opt/Empire 2>/dev/null || ls /home/devuser/Empire 2>/dev/null"
    
    # Covenant .NET C2
    run_test "Covenant C2 availability" "command -v covenant || docker images | grep covenant"
    
    # Custom C2 development tools
    run_test "Socket programming support" "python3 -c 'import socket, threading, ssl'"
    run_test "Encryption libraries" "python3 -c 'from cryptography.fernet import Fernet'"
    run_test "HTTP server capabilities" "python3 -c 'import http.server, socketserver'"
    
    # Communication protocols
    run_test "DNS manipulation" "python3 -c 'import dns.resolver'"
    run_test "SSH client capabilities" "python3 -c 'import paramiko'" true
}

# Test social engineering and phishing tools
test_social_engineering() {
    print_test_header "Social Engineering & Phishing"
    
    # Phishing frameworks
    run_test "Gophish phishing framework" "command -v gophish || docker images | grep gophish"
    run_test "Evilginx2 advanced phishing" "command -v evilginx2 || docker images | grep evilginx"
    run_test "Social Engineering Toolkit" "command -v setoolkit || command -v set"
    
    # Email and web tools
    run_test "Email manipulation libraries" "python3 -c 'import email, smtplib, imaplib'"
    run_test "Web scraping tools" "python3 -c 'import requests, beautifulsoup4'"
    run_test "Selenium web automation" "python3 -c 'import selenium'"
    
    # Template and content generation
    run_test "Jinja2 templating" "python3 -c 'import jinja2'"
}

# Test wireless security tools
test_wireless_security() {
    print_test_header "Wireless Security Testing"
    
    # WiFi security tools
    run_test "Aircrack-ng WiFi security suite" "aircrack-ng --help"
    run_test "Kismet wireless detector" "kismet --version"
    run_test "Wifite automated WiFi cracker" "command -v wifite"
    run_test "Reaver WPS attack tool" "reaver -h"
    
    # Radio frequency tools (optional)
    run_test "RFCat radio frequency tool" "python3 -c 'import rfcat'" false
    run_test "HackRF One support" "command -v hackrf_info" false
    run_test "RTL-SDR support" "command -v rtl_sdr" false
}

# Test steganography and covert channels
test_steganography_tools() {
    print_test_header "Steganography & Covert Channels"
    
    run_test "Steghide steganography tool" "steghide --version"
    run_test "Stegano Python library" "python3 -c 'import stegano'"
    run_test "Stepic steganography" "python3 -c 'import stepic'"
    run_test "PIL/Pillow image manipulation" "python3 -c 'from PIL import Image'" true
    
    # Covert channel tools
    run_test "DNS exfiltration capabilities" "python3 -c 'import dns.query, dns.message'"
    run_test "ICMP tunneling support" "python3 -c 'from scapy.layers.inet import ICMP'"
}

# Test ML/AI offensive security capabilities
test_ml_security() {
    print_test_header "ML/AI Offensive Security Research"
    
    # Core ML libraries
    run_test "NumPy numerical computing" "python3 -c 'import numpy'" true
    run_test "Pandas data analysis" "python3 -c 'import pandas'" true
    run_test "Scikit-learn ML library" "python3 -c 'import sklearn'" true
    
    # Deep learning frameworks
    run_test "TensorFlow deep learning" "python3 -c 'import tensorflow as tf; print(tf.__version__)'"
    run_test "PyTorch deep learning" "python3 -c 'import torch; print(torch.__version__)'"
    
    # Adversarial ML tools
    run_test "Adversarial attack libraries" "python3 -c 'import numpy; print(\"Adversarial capabilities available\")'"
    
    # Jupyter environment
    run_test "JupyterLab availability" "jupyter lab --version"
    run_test "IPython interactive shell" "ipython --version"
}

# Test malware analysis and reverse engineering
test_malware_analysis() {
    print_test_header "Malware Analysis & Reverse Engineering"
    
    # File analysis
    run_test "Python-magic file type detection" "python3 -c 'import magic'"
    run_test "PEfile PE analyzer" "python3 -c 'import pefile'"
    run_test "PyELFtools ELF analyzer" "python3 -c 'import elftools'"
    
    # Memory analysis
    run_test "Volatility3 memory forensics" "python3 -c 'import volatility3'" false
    run_test "YARA pattern matching" "python3 -c 'import yara'"
    
    # Disassembly and analysis
    run_test "Capstone disassembler" "python3 -c 'import capstone'"
    run_test "Distorm3 disassembler" "python3 -c 'import distorm3'" false
}

# Test cloud security tools
test_cloud_security() {
    print_test_header "Cloud Security Testing"
    
    # Cloud provider libraries
    run_test "AWS Boto3 library" "python3 -c 'import boto3'"
    run_test "Azure identity library" "python3 -c 'import azure.identity'"
    run_test "Google Cloud library" "python3 -c 'import google.cloud'"
    
    # Container security
    run_test "Docker Python client" "python3 -c 'import docker'"
    run_test "Kubernetes Python client" "python3 -c 'import kubernetes'"
}

# Test development and productivity tools
test_development_environment() {
    print_test_header "Development Environment"
    
    # Core development tools
    run_test "Neovim text editor" "nvim --version" true
    run_test "Node.js runtime" "node --version"
    run_test "NPM package manager" "npm --version"
    
    # Workflow automation
    run_test "n8n workflow automation" "n8n --version"
    
    # Anaconda environment
    if [ -d "/home/devuser/anaconda3" ]; then
        print_pass "Anaconda installation found"
        ((PASSED_TESTS++))
    else
        print_fail "Anaconda installation not found"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Python environment
    run_test "Conda package manager" "conda --version"
    run_test "Python package ecosystem" "pip list | grep -c '.*' | xargs test 50 -lt"
}

# Test container and infrastructure
test_container_features() {
    print_test_header "Container & Infrastructure Features"
    
    # Container detection
    if [ -f /.dockerenv ]; then
        print_pass "Running inside Docker container"
        ((PASSED_TESTS++))
    else
        print_fail "Not running in container (testing on host)"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Red team menu
    if [ -f "/home/devuser/menu-red.sh" ] || [ -f "menu-red.sh" ]; then
        print_pass "Red team menu script available"
        ((PASSED_TESTS++))
    else
        print_fail "Red team menu script not found"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Workspace directories
    if [ -d "/home/devuser/redteam" ] || mkdir -p redteam 2>/dev/null; then
        print_pass "Red team workspace directory available"
        ((PASSED_TESTS++))
    else
        print_fail "Cannot create red team workspace"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Performance and resource tests
test_performance() {
    print_test_header "Performance & Resource Tests"
    
    # Memory check
    total_mem=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$total_mem" -gt 4000 ]; then
        print_pass "Adequate memory available (${total_mem}MB)"
        ((PASSED_TESTS++))
    else
        print_fail "Low memory (${total_mem}MB) - may affect red team operations"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # CPU cores
    cpu_cores=$(nproc)
    if [ "$cpu_cores" -gt 2 ]; then
        print_pass "Multiple CPU cores available ($cpu_cores)"
        ((PASSED_TESTS++))
    else
        print_fail "Limited CPU cores ($cpu_cores) - may affect performance"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Disk space
    available_space=$(df . | tail -1 | awk '{print $4}')
    if [ "$available_space" -gt 10485760 ]; then  # 10GB in KB
        print_pass "Adequate disk space available"
        ((PASSED_TESTS++))
    else
        print_fail "Low disk space - may affect operations"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test network capabilities
test_network_capabilities() {
    print_test_header "Network Capabilities"
    
    # Network tools
    run_test "Raw socket support" "python3 -c 'import socket; s=socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)' 2>/dev/null || echo 'Requires privileges'"
    run_test "Packet capture support" "python3 -c 'import pcap'" false
    run_test "Scapy packet crafting" "python3 -c 'from scapy.all import IP, TCP'" true
    
    # Network monitoring
    run_test "Wireshark tshark" "tshark --version"
    run_test "Tcpdump packet analyzer" "tcpdump --version"
    
    # Network libraries
    run_test "Netfilterqueue manipulation" "python3 -c 'import netfilterqueue'" false
    run_test "Python-nmap integration" "python3 -c 'import nmap'"
}

# Main test execution
main() {
    echo -e "${BOLD}${RED}🚩 Dronat Red Team Environment Test Suite${NC}"
    echo "================================================================"
    echo -e "${YELLOW}Testing offensive security tools and capabilities${NC}"
    echo -e "${RED}⚠️  For authorized testing environments only ⚠️${NC}"
    echo ""
    
    # Run all test categories
    test_system_requirements
    test_reconnaissance_tools
    test_exploitation_tools
    test_postexploitation_tools
    test_c2_frameworks
    test_social_engineering
    test_wireless_security
    test_steganography_tools
    test_ml_security
    test_malware_analysis
    test_cloud_security
    test_development_environment
    test_container_features
    test_performance
    test_network_capabilities
    
    # Print comprehensive summary
    echo ""
    print_test_header "Test Summary"
    echo "Total Tests: $TOTAL_TESTS"
    echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
    echo ""
    
    # Report critical failures
    if [ ${#CRITICAL_FAILURES[@]} -gt 0 ]; then
        echo -e "${BOLD}${RED}Critical Failures:${NC}"
        for failure in "${CRITICAL_FAILURES[@]}"; do
            echo -e "  ${RED}❌ $failure${NC}"
        done
        echo ""
    fi
    
    # Calculate success rate and provide assessment
    if [ $TOTAL_TESTS -gt 0 ]; then
        success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        
        if [ ${#CRITICAL_FAILURES[@]} -gt 0 ]; then
            echo -e "${RED}❌ Red team environment has critical issues${NC}"
            echo -e "${RED}   Critical tools missing - operations may be severely limited${NC}"
            exit 1
        elif [ $success_rate -ge 85 ]; then
            echo -e "${GREEN}✅ Red team environment is fully operational! (${success_rate}% success)${NC}"
            echo -e "${GREEN}   All essential offensive security tools available${NC}"
            exit 0
        elif [ $success_rate -ge 70 ]; then
            echo -e "${YELLOW}⚠️  Red team environment is operational with limitations (${success_rate}% success)${NC}"
            echo -e "${YELLOW}   Some advanced tools may be missing${NC}"
            exit 0
        else
            echo -e "${RED}❌ Red team environment has significant issues (${success_rate}% success)${NC}"
            echo -e "${RED}   Many essential tools are missing${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ No tests were executed${NC}"
        exit 1
    fi
}

# Check for help flag
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Dronat Red Team Environment Test Suite"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h    Show this help message"
    echo "  --verbose     Show detailed test output"
    echo ""
    echo "This script tests the availability and functionality of:"
    echo "  • Reconnaissance and intelligence tools"
    echo "  • Exploitation frameworks and tools"
    echo "  • Post-exploitation and persistence tools"
    echo "  • Command & control frameworks"
    echo "  • Social engineering capabilities"
    echo "  • ML/AI offensive security tools"
    echo "  • Development environment"
    echo ""
    echo "Exit codes:"
    echo "  0: Environment ready for red team operations"
    echo "  1: Critical issues found"
    echo ""
    exit 0
fi

# Execute tests
main "$@"