#!/bin/bash
# Enhanced package manager abstraction script for cross-distro compatibility
# Supports Ubuntu/Debian (apt) and Arch Linux (pacman)
# Version 2.0 - Enhanced for Dronat 2024 update

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script metadata
SCRIPT_VERSION="2.0"
SCRIPT_NAME="Enhanced Package Manager for Dronat"

# Logging functions with timestamps
log_with_timestamp() {
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log_info() {
    log_with_timestamp "${BLUE}[INFO]${NC} $1"
}

log_success() {
    log_with_timestamp "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    log_with_timestamp "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    log_with_timestamp "${RED}[ERROR]${NC} $1" >&2
}

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        log_with_timestamp "${PURPLE}[DEBUG]${NC} $1"
    fi
}

# Progress indicator
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local percent=$((current * 100 / total))
    printf "\r${CYAN}[%3d%%]${NC} %s" "$percent" "$message"
    if [[ $current -eq $total ]]; then
        echo ""
    fi
}

# Enhanced system detection with version info
detect_distro() {
    local distro="unknown"
    local version="unknown"
    
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        distro="$ID"
        version="$VERSION_ID"
    elif [[ -f /etc/debian_version ]]; then
        distro="debian"
        version=$(cat /etc/debian_version)
    elif [[ -f /etc/arch-release ]]; then
        distro="arch"
        version="rolling"
    else
        log_error "Unable to detect Linux distribution"
        exit 1
    fi
    
    log_info "Detected: $distro $version"
    echo "$distro"
}

# Check if running with sufficient privileges
check_privileges() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root. This is not recommended for regular usage."
    elif ! sudo -n true 2>/dev/null; then
        log_error "This script requires sudo privileges. Please run with sudo or ensure passwordless sudo is configured."
        exit 1
    fi
}

# Retry mechanism for network operations
retry_command() {
    local max_attempts=$1
    shift
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        log_debug "Attempt $attempt/$max_attempts: $*"
        if "$@"; then
            return 0
        fi
        
        if [[ $attempt -lt $max_attempts ]]; then
            log_warning "Command failed, retrying in 5 seconds... (attempt $attempt/$max_attempts)"
            sleep 5
        fi
        ((attempt++))
    done
    
    log_error "Command failed after $max_attempts attempts: $*"
    return 1
}

# Enhanced update cache with retry and error handling
update_cache() {
    local distro="$1"
    log_info "Updating package manager cache for $distro..."
    
    case "$distro" in
        ubuntu|debian)
            retry_command 3 apt-get update
            ;;
        arch|manjaro)
            retry_command 3 pacman -Sy
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
    
    log_success "Package cache updated successfully"
}

# Enhanced package installation with progress tracking
install_packages() {
    local distro="$1"
    shift
    local packages=("$@")
    local total=${#packages[@]}
    local current=0
    
    if [[ $total -eq 0 ]]; then
        log_warning "No packages specified for installation"
        return 0
    fi
    
    log_info "Installing $total packages for $distro: ${packages[*]}"
    
    case "$distro" in
        ubuntu|debian)
            # Check which packages are already installed
            local to_install=()
            for pkg in "${packages[@]}"; do
                if ! dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
                    to_install+=("$pkg")
                fi
                ((current++))
                show_progress "$current" "$total" "Checking package: $pkg"
            done
            
            if [[ ${#to_install[@]} -eq 0 ]]; then
                log_success "All packages are already installed"
                return 0
            fi
            
            log_info "Installing ${#to_install[@]} new packages: ${to_install[*]}"
            DEBIAN_FRONTEND=noninteractive apt-get install -y "${to_install[@]}"
            ;;
        arch|manjaro)
            pacman -S --noconfirm --needed "${packages[@]}"
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
    
    log_success "Packages installed successfully"
}

# Clean package manager cache
clean_cache() {
    local distro="$1"
    log_info "Cleaning package manager cache..."
    
    case "$distro" in
        ubuntu|debian)
            apt-get autoremove -y
            apt-get autoclean
            rm -rf /var/lib/apt/lists/*
            ;;
        arch|manjaro)
            pacman -Sc --noconfirm
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
    
    log_success "Package cache cleaned"
}

# Enhanced development packages installation
install_dev_packages() {
    local distro="$1"
    
    log_info "Installing enhanced development packages for $distro"
    
    case "$distro" in
        ubuntu|debian)
            local ubuntu_packages=(
                # Build essentials
                "build-essential"
                "cmake"
                "pkg-config"
                "autoconf"
                "automake"
                "libtool"
                
                # Core utilities
                "curl"
                "wget"
                "unzip"
                "zip"
                "tar"
                "gzip"
                "git"
                "sudo"
                "vim"
                "nano"
                
                # Modern CLI tools
                "ripgrep"
                "fd-find"
                "bat"
                "exa"
                "htop"
                "tree"
                "jq"
                "yq"
                
                # Python development
                "python3"
                "python3-pip"
                "python3-venv"
                "python3-dev"
                "python3-setuptools"
                "python3-wheel"
                
                # System libraries for Python packages
                "libssl-dev"
                "libffi-dev"
                "libbz2-dev"
                "libreadline-dev"
                "libsqlite3-dev"
                "libncursesw5-dev"
                "libxml2-dev"
                "libxmlsec1-dev"
                "liblzma-dev"
                
                # Terminal and session management
                "tmux"
                "screen"
                "zsh"
                
                # Network and security
                "openssh-client"
                "openssh-server"
                "ca-certificates"
                "gnupg"
                "lsb-release"
                "software-properties-common"
                "apt-transport-https"
                
                # Development libraries
                "libgit2-dev"
                "libcurl4-openssl-dev"
                
                # Container and virtualization
                "docker.io"
                "docker-compose"
                
                # Monitoring and system info
                "neofetch"
                "lsof"
                "strace"
                "tcpdump"
                "net-tools"
                "iotop"
                "iftop"
            )
            install_packages "$distro" "${ubuntu_packages[@]}"
            ;;
        arch|manjaro)
            local arch_packages=(
                # Build essentials
                "base-devel"
                "cmake"
                "pkgconf"
                
                # Core utilities
                "curl"
                "wget"
                "unzip"
                "zip"
                "tar"
                "gzip"
                "git"
                "sudo"
                "vim"
                "nano"
                
                # Modern CLI tools
                "ripgrep"
                "fd"
                "bat"
                "exa"
                "htop"
                "tree"
                "jq"
                "yq"
                
                # Python development
                "python"
                "python-pip"
                "python-virtualenv"
                
                # Terminal and session management
                "tmux"
                "screen"
                "zsh"
                
                # Network and security
                "openssh"
                "ca-certificates"
                "which"
                
                # Container and virtualization
                "docker"
                "docker-compose"
                
                # Monitoring tools
                "neofetch"
                "lsof"
                "strace"
                "tcpdump"
                "net-tools"
                "iotop"
                "iftop"
            )
            install_packages "$distro" "${arch_packages[@]}"
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

# Install latest Node.js LTS (22.x)
install_nodejs() {
    local distro="$1"
    
    log_info "Installing Node.js 22 LTS for $distro"
    
    case "$distro" in
        ubuntu|debian)
            # Add NodeSource repository for Node.js 22.x
            curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
            apt-get install -y nodejs
            
            # Install global npm packages
            npm install -g npm@latest
            npm install -g yarn
            npm install -g pnpm
            ;;
        arch|manjaro)
            pacman -S --noconfirm nodejs npm yarn
            npm install -g npm@latest
            npm install -g pnpm
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
    
    # Verify installation
    local node_version=$(node --version 2>/dev/null || echo "not installed")
    local npm_version=$(npm --version 2>/dev/null || echo "not installed")
    
    log_success "Node.js installed: $node_version"
    log_success "npm installed: $npm_version"
}

# Enhanced GitHub CLI installation
install_github_cli() {
    local distro="$1"
    
    log_info "Installing GitHub CLI for $distro"
    
    case "$distro" in
        ubuntu|debian)
            # Add GitHub CLI repository
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
                sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
                sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            retry_command 3 apt-get update
            apt-get install -y gh
            ;;
        arch|manjaro)
            pacman -S --noconfirm github-cli
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
    
    # Verify installation
    local gh_version=$(gh --version 2>/dev/null | head -1 || echo "not installed")
    log_success "GitHub CLI installed: $gh_version"
}

# Install Python ML/AI packages
install_python_ml_packages() {
    log_info "Installing comprehensive Python ML/AI packages..."
    
    # Upgrade pip first
    python3 -m pip install --upgrade pip setuptools wheel
    
    # Core ML frameworks
    python3 -m pip install tensorflow torch torchvision torchaudio scikit-learn xgboost lightgbm catboost
    
    # Data science and analysis
    python3 -m pip install pandas numpy scipy matplotlib seaborn plotly
    
    # Advanced ML and AI
    python3 -m pip install transformers accelerate diffusers peft datasets tokenizers
    
    # MLOps and experiment tracking
    python3 -m pip install mlflow wandb tensorboard clearml
    
    # Additional packages for complete development environment
    python3 -m pip install jupyterlab notebook gradio streamlit fastapi uvicorn
    
    log_success "Python ML/AI packages installed successfully"
}

# Enhanced cleanup with selective removal
clean_cache() {
    local distro="$1"
    log_info "Cleaning package manager cache for $distro..."
    
    case "$distro" in
        ubuntu|debian)
            apt-get autoremove -y
            apt-get autoclean
            apt-get clean
            rm -rf /var/lib/apt/lists/*
            # Clean pip cache
            python3 -m pip cache purge 2>/dev/null || true
            ;;
        arch|manjaro)
            pacman -Sc --noconfirm
            python3 -m pip cache purge 2>/dev/null || true
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
    
    log_success "Package cache cleaned successfully"
}

# System verification and health check
verify_installation() {
    log_info "Verifying installation..."
    
    local errors=0
    
    # Check essential tools
    local tools=("git" "curl" "wget" "python3" "pip3" "node" "npm" "gh" "nvim" "tmux")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            local version=$("$tool" --version 2>/dev/null | head -1 || echo "unknown")
            log_success "$tool: $version"
        else
            log_error "$tool: not found"
            ((errors++))
        fi
    done
    
    # Check Python packages
    local python_packages=("tensorflow" "torch" "sklearn" "pandas" "numpy" "jupyter")
    for pkg in "${python_packages[@]}"; do
        if python3 -c "import $pkg" 2>/dev/null; then
            local version=$(python3 -c "import $pkg; print($pkg.__version__)" 2>/dev/null || echo "unknown")
            log_success "Python $pkg: $version"
        else
            log_warning "Python $pkg: not available"
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        log_success "All essential tools verified successfully!"
    else
        log_warning "$errors essential tools are missing. Please check the installation."
    fi
    
    return $errors
}

# Display usage information
show_usage() {
    echo -e "${BOLD}$SCRIPT_NAME v$SCRIPT_VERSION${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -v, --version       Show script version"
    echo "  -d, --debug         Enable debug output"
    echo "  --dry-run           Show what would be installed without actually installing"
    echo "  --dev-only          Install only development packages"
    echo "  --ml-only           Install only ML/AI packages"
    echo "  --no-cleanup        Skip cleanup after installation"
    echo "  --verify-only       Only verify existing installation"
    echo ""
    echo "Examples:"
    echo "  $0                  # Full installation"
    echo "  $0 --dev-only       # Install only development packages"
    echo "  $0 --verify-only    # Verify existing installation"
    echo "  $0 --debug          # Full installation with debug output"
}

# Main execution function
main() {
    local dry_run=false
    local dev_only=false
    local ml_only=false
    local no_cleanup=false
    local verify_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--version)
                echo "$SCRIPT_NAME v$SCRIPT_VERSION"
                exit 0
                ;;
            -d|--debug)
                export DEBUG=true
                ;;
            --dry-run)
                dry_run=true
                ;;
            --dev-only)
                dev_only=true
                ;;
            --ml-only)
                ml_only=true
                ;;
            --no-cleanup)
                no_cleanup=true
                ;;
            --verify-only)
                verify_only=true
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
        shift
    done
    
    # Header
    echo -e "${BOLD}${CYAN}$SCRIPT_NAME v$SCRIPT_VERSION${NC}"
    echo -e "${BLUE}Enhanced package installation for Dronat environment${NC}"
    echo ""
    
    # Verify-only mode
    if [[ "$verify_only" == "true" ]]; then
        verify_installation
        exit $?
    fi
    
    # Check system requirements
    check_privileges
    local distro=$(detect_distro)
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "DRY RUN MODE: Would install packages for $distro"
        exit 0
    fi
    
    # Update package cache
    update_cache "$distro"
    
    # Install packages based on options
    if [[ "$ml_only" == "true" ]]; then
        install_python_ml_packages
    elif [[ "$dev_only" == "true" ]]; then
        install_dev_packages "$distro"
        install_nodejs "$distro"
        install_github_cli "$distro"
    else
        # Full installation
        install_dev_packages "$distro"
        install_nodejs "$distro"
        install_github_cli "$distro"
        install_python_ml_packages
    fi
    
    # Cleanup
    if [[ "$no_cleanup" != "true" ]]; then
        clean_cache "$distro"
    fi
    
    # Verify installation
    verify_installation
    
    log_success "Installation completed! 🎉"
    echo ""
    echo -e "${BOLD}Next steps:${NC}"
    echo -e "  1. Restart your shell or run: ${CYAN}source ~/.bashrc${NC}"
    echo -e "  2. Configure GitHub CLI: ${CYAN}gh auth login${NC}"
    echo -e "  3. Start using the enhanced development environment!"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# Install Python packages including OpenBB, ShellGPT, and ML/AI tools
install_python_packages() {
    log_info "Installing Python packages including OpenBB, ShellGPT, and comprehensive ML/AI tools"
    
    # Install essential Python packages
    pip3 install --upgrade pip
    
    # Core packages
    pip3 install meson openbb shell-gpt jupyter ipython pandas numpy matplotlib
    
    # ML/AI Frameworks
    log_info "Installing ML/AI frameworks..."
    pip3 install tensorflow torch torchvision torchaudio
    pip3 install scikit-learn xgboost lightgbm catboost
    
    # Deep learning and transformers
    pip3 install keras transformers accelerate diffusers
    
    # Data science tools
    pip3 install seaborn plotly scipy
    
    # Jupyter ecosystem
    pip3 install jupyterlab notebook jupyterlab-git
    
    # Computer vision
    pip3 install opencv-python pillow albumentations
    
    # Natural language processing
    pip3 install nltk spacy textblob gensim
    
    # MLOps and experiment tracking
    pip3 install mlflow wandb tensorboard
    
    # AutoML and hyperparameter tuning
    pip3 install optuna hyperopt
    
    # Model deployment and serving
    pip3 install fastapi uvicorn gradio streamlit
    
    # Additional utilities
    pip3 install ipywidgets tqdm joblib
    
    log_success "Python packages including OpenBB, ShellGPT, and ML/AI tools installed successfully"
}

# Install Docker for Shellngn Pro support
install_docker() {
    local distro="$1"
    
    log_info "Installing Docker for Shellngn Pro support"
    
    case "$distro" in
        ubuntu|debian)
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Set up the repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Update package index
            apt-get update
            
            # Install Docker Engine
            apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            
            # Add user to docker group (requires re-login to take effect)
            usermod -aG docker $USER || true
            ;;
        arch|manjaro)
            pacman -S --noconfirm docker docker-compose
            systemctl enable docker
            usermod -aG docker $USER || true
            ;;
        *)
            log_warning "Docker installation not configured for $distro. Please install Docker manually for Shellngn Pro support."
            return 1
            ;;
    esac
    
    log_success "Docker installed successfully. Note: You may need to re-login for group changes to take effect."
}

# Main function to orchestrate package installation
main() {
    log_info "Starting cross-distro package installation"
    
    # Detect distribution
    DISTRO=$(detect_distro)
    log_info "Detected distribution: $DISTRO"
    
    # Update package cache
    update_cache "$DISTRO"
    
    # Install development packages
    install_dev_packages "$DISTRO"
    
    # Install GitHub CLI
    install_github_cli "$DISTRO"
    
    # Install Python packages including OpenBB
    install_python_packages
    
    # Install Docker for Shellngn Pro support  
    install_docker "$DISTRO"
    
    # Clean package cache
    clean_cache "$DISTRO"
    
    log_success "All packages installed successfully!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi