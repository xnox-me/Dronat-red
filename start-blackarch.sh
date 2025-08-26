#!/bin/bash

# Dronat BlackArch Quick Start Script
# This script helps you build, test, and run the BlackArch penetration testing environment

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BOLD}${PURPLE}$1${NC}"
}

# Check if Docker is available
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running or user lacks permissions"
        exit 1
    fi
    
    print_success "Docker is available and running"
}

# Build the BlackArch container
build_container() {
    print_header "🔨 Building Dronat BlackArch Container"
    print_status "This may take 15-30 minutes depending on your internet connection..."
    
    if docker build -f Dockerfile.blackarch -t dronat-blackarch:latest .; then
        print_success "BlackArch container built successfully!"
    else
        print_error "Failed to build BlackArch container"
        exit 1
    fi
}

# Test the container
test_container() {
    print_header "🧪 Testing BlackArch Container"
    
    # Basic functionality test
    print_status "Testing basic container functionality..."
    if docker run --rm dronat-blackarch:latest python3 -c "print('Container test successful!')"; then
        print_success "Basic container test passed"
    else
        print_error "Basic container test failed"
        return 1
    fi
    
    # Test security tools
    print_status "Testing security tools availability..."
    tools=("nmap" "nikto" "hashcat" "john" "hydra")
    for tool in "${tools[@]}"; do
        if docker run --rm dronat-blackarch:latest which $tool &> /dev/null; then
            print_success "$tool is available"
        else
            print_warning "$tool not found (may be installed via alternative method)"
        fi
    done
    
    # Test Python security libraries
    print_status "Testing Python security libraries..."
    python_libs=("scapy" "requests" "cryptography" "paramiko")
    for lib in "${python_libs[@]}"; do
        if docker run --rm dronat-blackarch:latest python3 -c "import $lib; print('$lib imported successfully')" &> /dev/null; then
            print_success "Python library $lib available"
        else
            print_warning "Python library $lib not available"
        fi
    done
}

# Run the container interactively
run_interactive() {
    print_header "🚀 Starting BlackArch Interactive Environment"
    print_status "Container will start with the security menu interface"
    print_status "Available ports:"
    print_status "  - 8888: JupyterLab (ML/AI Security Research)"
    print_status "  - 5678: n8n Workflow Automation"
    print_status "  - 8080: Shellngn Pro Web Interface"
    echo ""
    
    docker run -it --rm \
        --name dronat-blackarch \
        -p 8888:8888 \
        -p 5678:5678 \
        -p 8080:8080 \
        -p 6006:6006 \
        -p 7860:7860 \
        -p 8501:8501 \
        -v "$(pwd)/workspace:/home/devuser/workspace" \
        -v "$(pwd)/reports:/home/devuser/reports" \
        --cap-add=NET_ADMIN \
        --cap-add=NET_RAW \
        dronat-blackarch:latest
}

# Run with Docker Compose
run_compose() {
    print_header "🐳 Starting with Docker Compose"
    
    if [ ! -f docker-compose-blackarch.yml ]; then
        print_error "docker-compose-blackarch.yml not found"
        exit 1
    fi
    
    docker-compose -f docker-compose-blackarch.yml up -d
    print_success "BlackArch environment started with Docker Compose"
    print_status "Access the environment at http://localhost:8080"
}

# Stop Docker Compose services
stop_compose() {
    print_header "🛑 Stopping Docker Compose Services"
    
    if [ -f docker-compose-blackarch.yml ]; then
        docker-compose -f docker-compose-blackarch.yml down
        print_success "BlackArch environment stopped"
    else
        print_warning "docker-compose-blackarch.yml not found"
    fi
}

# Clean up containers and images
cleanup() {
    print_header "🧹 Cleaning Up"
    
    # Stop and remove containers
    if docker ps -a | grep -q dronat-blackarch; then
        print_status "Stopping and removing BlackArch containers..."
        docker stop $(docker ps -aq --filter name=dronat-blackarch) || true
        docker rm $(docker ps -aq --filter name=dronat-blackarch) || true
    fi
    
    # Remove images if requested
    read -p "Remove BlackArch Docker images? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Removing BlackArch images..."
        docker rmi dronat-blackarch:latest || true
    fi
    
    print_success "Cleanup completed"
}

# Show usage information
show_usage() {
    print_header "🔒 Dronat BlackArch Quick Start"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build the BlackArch container"
    echo "  test        Test the built container"
    echo "  run         Run the container interactively"
    echo "  compose     Start with Docker Compose"
    echo "  stop        Stop Docker Compose services"
    echo "  cleanup     Clean up containers and images"
    echo "  all         Build, test, and run (recommended for first time)"
    echo ""
    echo "Examples:"
    echo "  $0 all              # Complete setup and run"
    echo "  $0 build            # Just build the container"
    echo "  $0 run              # Run with basic setup"
    echo "  $0 compose          # Run with full Docker Compose setup"
    echo ""
    echo "Security Notes:"
    echo "  - This container includes penetration testing tools"
    echo "  - Only use on systems you own or have permission to test"
    echo "  - Follow responsible disclosure practices"
    echo "  - Some tools require privileged mode (NET_ADMIN, NET_RAW)"
    echo ""
}

# Create workspace directories
setup_workspace() {
    print_status "Setting up workspace directories..."
    
    mkdir -p workspace/{projects,scripts,wordlists,reports,exploits}
    mkdir -p reports/{network,web,wireless,binary}
    
    # Create sample files
    cat > workspace/README.md << 'EOF'
# Dronat BlackArch Workspace

This directory is mounted into the container for persistent storage.

## Directory Structure
- `projects/` - Your security research projects
- `scripts/` - Custom scripts and tools
- `wordlists/` - Custom wordlists for testing
- `reports/` - Security assessment reports
- `exploits/` - Proof-of-concept exploits

## Getting Started
1. Use the interactive menu when starting the container
2. Access JupyterLab at http://localhost:8888 for ML/AI security research
3. Use n8n at http://localhost:5678 for workflow automation
4. Access Shellngn Pro at http://localhost:8080 for web-based terminal

## Security Reminder
Only test systems you own or have explicit permission to test.
Follow responsible disclosure practices for any vulnerabilities found.
EOF

    print_success "Workspace directories created"
}

# Main script logic
main() {
    case "${1:-}" in
        "build")
            check_docker
            build_container
            ;;
        "test")
            check_docker
            test_container
            ;;
        "run")
            check_docker
            setup_workspace
            run_interactive
            ;;
        "compose")
            check_docker
            setup_workspace
            run_compose
            ;;
        "stop")
            stop_compose
            ;;
        "cleanup")
            cleanup
            ;;
        "all")
            check_docker
            setup_workspace
            build_container
            test_container
            run_interactive
            ;;
        "help"|"--help"|"-h")
            show_usage
            ;;
        "")
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"