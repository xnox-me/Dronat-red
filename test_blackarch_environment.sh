#!/bin/bash

# Dronat BlackArch Security Tools Test Suite
# Comprehensive testing of all security tools and capabilities

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

# Functions for output
print_test_header() {
    echo -e "\n${BOLD}${PURPLE}🧪 $1${NC}"
    echo "=================================="
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

# Test function wrapper
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    print_test "$test_name"
    
    if eval "$test_command" &>/dev/null; then
        print_pass "$test_name"
        return 0
    else
        print_fail "$test_name"
        return 1
    fi
}

# Test system requirements
test_system() {
    print_test_header "System Requirements"
    
    run_test "Python 3 availability" "python3 --version"
    run_test "Pip availability" "pip --version"
    run_test "Git availability" "git --version"
    run_test "Curl availability" "curl --version"
    run_test "Wget availability" "wget --version"
}

# Test network reconnaissance tools
test_network_recon() {
    print_test_header "Network Reconnaissance Tools"
    
    run_test "Nmap availability" "nmap --version"
    run_test "Masscan availability" "masscan --version"
    run_test "Dirb availability" "dirb"
    run_test "Nikto availability" "nikto -Version"
    run_test "Netcat availability" "nc -h"
    run_test "Tcpdump availability" "tcpdump --version"
    
    # Test optional tools
    if command -v gobuster &>/dev/null; then
        run_test "Gobuster availability" "gobuster version"
    else
        print_skip "Gobuster not installed (may be available via alternative method)"
    fi
    
    if command -v theharvester &>/dev/null; then
        run_test "TheHarvester availability" "theharvester --help"
    else
        print_skip "TheHarvester not installed"
    fi
}

# Test web security tools
test_web_security() {
    print_test_header "Web Security Tools"
    
    run_test "SQLmap availability" "sqlmap --version"
    
    if command -v burpsuite &>/dev/null; then
        print_pass "Burp Suite available"
        ((PASSED_TESTS++))
    else
        print_skip "Burp Suite not available via command line"
    fi
    
    if command -v zaproxy &>/dev/null || command -v zap.sh &>/dev/null; then
        print_pass "OWASP ZAP available"
        ((PASSED_TESTS++))
    else
        print_skip "OWASP ZAP not installed"
    fi
    
    ((TOTAL_TESTS += 2))
}

# Test password cracking tools
test_password_tools() {
    print_test_header "Password & Hash Cracking Tools"
    
    run_test "John the Ripper availability" "john --version"
    run_test "Hashcat availability" "hashcat --version"
    run_test "Hydra availability" "hydra -h"
    
    if command -v medusa &>/dev/null; then
        run_test "Medusa availability" "medusa -h"
    else
        print_skip "Medusa not installed"
    fi
}

# Test wireless security tools
test_wireless_tools() {
    print_test_header "Wireless Security Tools"
    
    if command -v aircrack-ng &>/dev/null; then
        run_test "Aircrack-ng availability" "aircrack-ng --help"
    else
        print_skip "Aircrack-ng not installed"
    fi
    
    if command -v kismet &>/dev/null; then
        run_test "Kismet availability" "kismet --version"
    else
        print_skip "Kismet not installed"
    fi
    
    if command -v wifite &>/dev/null; then
        run_test "Wifite availability" "wifite --help"
    else
        print_skip "Wifite not installed"
    fi
}

# Test binary analysis tools
test_binary_analysis() {
    print_test_header "Binary Analysis & Exploitation Tools"
    
    if command -v msfconsole &>/dev/null; then
        print_pass "Metasploit Framework available"
        ((PASSED_TESTS++))
    else
        print_skip "Metasploit not available"
    fi
    
    run_test "GDB availability" "gdb --version"
    
    if command -v r2 &>/dev/null || command -v radare2 &>/dev/null; then
        print_pass "Radare2 available"
        ((PASSED_TESTS++))
    else
        print_skip "Radare2 not installed"
    fi
    
    ((TOTAL_TESTS += 2))
}

# Test Python security libraries
test_python_security() {
    print_test_header "Python Security Libraries"
    
    # Core security libraries
    python_libs=(
        "scapy"
        "requests" 
        "cryptography"
        "paramiko"
        "impacket"
        "beautifulsoup4"
    )
    
    for lib in "${python_libs[@]}"; do
        run_test "Python library: $lib" "python3 -c 'import $lib'"
    done
    
    # Optional advanced libraries
    optional_libs=(
        "pwntools"
        "ropper"
        "capstone"
        "angr"
        "z3"
    )
    
    for lib in "${optional_libs[@]}"; do
        if python3 -c "import $lib" &>/dev/null; then
            print_pass "Python library: $lib (advanced)"
            ((PASSED_TESTS++))
        else
            print_skip "Python library: $lib not available"
        fi
        ((TOTAL_TESTS++))
    done
}

# Test ML/AI security tools
test_ml_security() {
    print_test_header "ML/AI Security Research Tools"
    
    ml_libs=(
        "numpy"
        "pandas"
        "scikit-learn"
        "matplotlib"
        "tensorflow"
        "torch"
    )
    
    for lib in "${ml_libs[@]}"; do
        run_test "ML library: $lib" "python3 -c 'import $lib'"
    done
    
    # Test Jupyter availability
    run_test "JupyterLab availability" "jupyter lab --version"
    run_test "IPython availability" "ipython --version"
}

# Test development environment
test_dev_environment() {
    print_test_header "Development Environment"
    
    run_test "Neovim availability" "nvim --version"
    run_test "Node.js availability" "node --version"
    run_test "NPM availability" "npm --version"
    
    if command -v n8n &>/dev/null; then
        run_test "n8n availability" "n8n --version"
    else
        print_skip "n8n not in PATH (may be installed locally)"
    fi
    
    # Test Anaconda
    if [ -d "/home/devuser/anaconda3" ]; then
        print_pass "Anaconda installation found"
        ((PASSED_TESTS++))
    else
        print_fail "Anaconda installation not found"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test file analysis tools
test_file_analysis() {
    print_test_header "File Analysis Tools"
    
    file_libs=(
        "python-magic"
        "pefile" 
        "pyelftools"
    )
    
    for lib in "${file_libs[@]}"; do
        run_test "File analysis library: ${lib//-/_}" "python3 -c 'import ${lib//-/_}'"
    done
}

# Test network analysis capabilities
test_network_analysis() {
    print_test_header "Network Analysis & Monitoring"
    
    run_test "Wireshark (tshark) availability" "tshark --version"
    
    network_libs=(
        "pyshark"
        "dpkt"
        "netaddr"
    )
    
    for lib in "${network_libs[@]}"; do
        if python3 -c "import $lib" &>/dev/null; then
            print_pass "Network library: $lib"
            ((PASSED_TESTS++))
        else
            print_skip "Network library: $lib not available"
        fi
        ((TOTAL_TESTS++))
    done
}

# Test container-specific functionality
test_container_features() {
    print_test_header "Container-Specific Features"
    
    # Test if we're in a container
    if [ -f /.dockerenv ]; then
        print_pass "Running inside Docker container"
        ((PASSED_TESTS++))
    else
        print_fail "Not running in container (testing on host)"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Test menu script
    if [ -f "/home/devuser/menu.sh" ] || [ -f "menu-blackarch.sh" ]; then
        print_pass "BlackArch menu script available"
        ((PASSED_TESTS++))
    else
        print_fail "BlackArch menu script not found"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Test directories
    if [ -d "/home/devuser/pentest" ] || mkdir -p pentest 2>/dev/null; then
        print_pass "Pentest workspace directory available"
        ((PASSED_TESTS++))
    else
        print_fail "Cannot create pentest workspace"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Performance test
test_performance() {
    print_test_header "Performance & Resource Tests"
    
    # Test memory
    total_mem=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$total_mem" -gt 1000 ]; then
        print_pass "Adequate memory available (${total_mem}MB)"
        ((PASSED_TESTS++))
    else
        print_fail "Low memory (${total_mem}MB) - may affect performance"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    # Test CPU cores
    cpu_cores=$(nproc)
    if [ "$cpu_cores" -gt 1 ]; then
        print_pass "Multiple CPU cores available ($cpu_cores)"
        ((PASSED_TESTS++))
    else
        print_fail "Single CPU core - may affect performance"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Main test execution
main() {
    echo -e "${BOLD}${CYAN}🔒 Dronat BlackArch Security Environment Test Suite${NC}"
    echo "================================================================"
    echo ""
    
    # Run all test categories
    test_system
    test_network_recon
    test_web_security
    test_password_tools
    test_wireless_tools
    test_binary_analysis
    test_python_security
    test_ml_security
    test_dev_environment
    test_file_analysis
    test_network_analysis
    test_container_features
    test_performance
    
    # Print summary
    echo ""
    print_test_header "Test Summary"
    echo "Total Tests: $TOTAL_TESTS"
    echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
    echo ""
    
    # Calculate success rate
    if [ $TOTAL_TESTS -gt 0 ]; then
        success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        if [ $success_rate -ge 80 ]; then
            echo -e "${GREEN}✅ Environment is ready for security testing! (${success_rate}% success)${NC}"
            exit 0
        elif [ $success_rate -ge 60 ]; then
            echo -e "${YELLOW}⚠️  Environment has some issues but is usable (${success_rate}% success)${NC}"
            exit 0
        else
            echo -e "${RED}❌ Environment has significant issues (${success_rate}% success)${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ No tests were executed${NC}"
        exit 1
    fi
}

# Execute tests
main "$@"