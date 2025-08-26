#!/bin/bash
# Comprehensive Test Suite for Dronat Enhanced Environment
# Version 2.0 - Updated for 2024

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

log_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
    ((TESTS_TOTAL++))
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Test function template
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    log_test "$test_name"
    
    if eval "$test_command" &>/dev/null; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        return 1
    fi
}

echo -e "${BOLD}${BLUE}🧪 Dronat Enhanced Environment Test Suite${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# System Information
log_info "System Information:"
echo "  OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'Unknown')"
echo "  Kernel: $(uname -r)"
echo "  Architecture: $(uname -m)"
echo "  User: $(whoami)"
echo "  Shell: $SHELL"
echo ""

# Test Core System Tools
echo -e "${YELLOW}Testing Core System Tools...${NC}"
run_test "Git installed" "command -v git"
run_test "Curl installed" "command -v curl"
run_test "Wget installed" "command -v wget"
run_test "Docker available" "command -v docker"
run_test "Sudo available" "command -v sudo"
echo ""

# Test Python Environment
echo -e "${YELLOW}Testing Python Environment...${NC}"
run_test "Python 3 installed" "command -v python3"
run_test "Pip installed" "command -v pip3"
run_test "Virtual environment support" "python3 -c 'import venv'"

if command -v python3 &>/dev/null; then
    python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
    log_info "Python version: $python_version"
fi
echo ""

# Test Node.js Environment
echo -e "${YELLOW}Testing Node.js Environment...${NC}"
run_test "Node.js installed" "command -v node"
run_test "NPM installed" "command -v npm"

if command -v node &>/dev/null; then
    node_version=$(node --version 2>&1)
    npm_version=$(npm --version 2>&1)
    log_info "Node.js version: $node_version"
    log_info "NPM version: $npm_version"
fi
echo ""

# Test Development Tools
echo -e "${YELLOW}Testing Development Tools...${NC}"
run_test "Neovim installed" "command -v nvim"
run_test "Tmux installed" "command -v tmux"
run_test "Ripgrep installed" "command -v rg"
run_test "GitHub CLI installed" "command -v gh"

if command -v nvim &>/dev/null; then
    nvim_version=$(nvim --version 2>&1 | head -1 | cut -d' ' -f2)
    log_info "Neovim version: $nvim_version"
fi
echo ""

# Test ML/AI Python Packages
echo -e "${YELLOW}Testing ML/AI Python Packages...${NC}"
python3 -c "
import sys
packages = [
    ('NumPy', 'numpy'),
    ('Pandas', 'pandas'),
    ('Matplotlib', 'matplotlib'),
    ('Scikit-learn', 'sklearn'),
    ('TensorFlow', 'tensorflow'),
    ('PyTorch', 'torch'),
    ('Transformers', 'transformers'),
    ('MLflow', 'mlflow'),
    ('Gradio', 'gradio'),
    ('Streamlit', 'streamlit'),
    ('JupyterLab', 'jupyterlab'),
    ('OpenBB', 'openbb')
]

passed = failed = 0
for name, module in packages:
    try:
        __import__(module)
        version = getattr(__import__(module), '__version__', 'unknown')
        print(f'\033[0;32m[PASS]\033[0m {name} ({version})')
        passed += 1
    except ImportError:
        print(f'\033[0;31m[FAIL]\033[0m {name} - not installed')
        failed += 1

print(f'\nML/AI Packages Summary: {passed} passed, {failed} failed')
sys.exit(failed)
" && ((TESTS_PASSED++)) || ((TESTS_FAILED++))
((TESTS_TOTAL++))
echo ""

# Test File Structure
echo -e "${YELLOW}Testing File Structure...${NC}"
run_test "Dockerfile exists" "[ -f Dockerfile ]"
run_test "README.md exists" "[ -f README.md ]"
run_test "menu.sh exists and executable" "[ -x menu.sh ]"
run_test "ml-helper.sh exists and executable" "[ -x ml-helper.sh ]"
run_test "install-packages.sh exists and executable" "[ -x install-packages.sh ]"
run_test "docker-compose.yml exists" "[ -f docker-compose.yml ]"
run_test ".dockerignore exists" "[ -f .dockerignore ]"
run_test "Neovim config exists" "[ -f nvim/init.lua ]"
echo ""

# Test Script Syntax
echo -e "${YELLOW}Testing Script Syntax...${NC}"
run_test "menu.sh syntax valid" "bash -n menu.sh"
run_test "ml-helper.sh syntax valid" "bash -n ml-helper.sh"
run_test "install-packages.sh syntax valid" "bash -n install-packages.sh"
echo ""

# Test Neovim Configuration
echo -e "${YELLOW}Testing Neovim Configuration...${NC}"
if command -v nvim &>/dev/null; then
    run_test "Neovim config syntax valid" "nvim --headless -c 'checkhealth' -c 'qa' 2>/dev/null"
    run_test "Neovim Lua config loads" "nvim --headless -c 'lua print(\"OK\")' -c 'qa' 2>/dev/null"
else
    log_fail "Neovim not available for testing"
    ((TESTS_FAILED+=2))
    ((TESTS_TOTAL+=2))
fi
echo ""

# Test Docker Configuration
echo -e "${YELLOW}Testing Docker Configuration...${NC}"
if command -v docker &>/dev/null; then
    run_test "Docker service running" "docker info"
    run_test "Docker-compose config valid" "docker-compose config"
else
    log_fail "Docker not available for testing"
    ((TESTS_FAILED+=2))
    ((TESTS_TOTAL+=2))
fi
echo ""

# Test Network Connectivity
echo -e "${YELLOW}Testing Network Connectivity...${NC}"
run_test "Internet connectivity" "curl -s --max-time 5 https://google.com"
run_test "GitHub connectivity" "curl -s --max-time 5 https://github.com"
run_test "PyPI connectivity" "curl -s --max-time 5 https://pypi.org"
echo ""

# Results Summary
echo -e "${BOLD}${BLUE}📊 Test Results Summary${NC}"
echo -e "${BLUE}═══════════════════════════════${NC}"
echo -e "Total Tests: ${BOLD}$TESTS_TOTAL${NC}"
echo -e "Passed: ${GREEN}${BOLD}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}${BOLD}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 All tests passed! Environment is ready.${NC}"
    exit 0
else
    success_rate=$((TESTS_PASSED * 100 / TESTS_TOTAL))
    echo -e "Success Rate: ${YELLOW}${BOLD}${success_rate}%${NC}"
    
    if [ $success_rate -ge 80 ]; then
        echo -e "${YELLOW}⚠️  Most tests passed. Minor issues detected.${NC}"
        exit 1
    else
        echo -e "${RED}❌ Significant issues detected. Please review failed tests.${NC}"
        exit 2
    fi
fi