#!/bin/bash

# Dronat Red Quick Start Script
# Automated deployment script for red team operations environment

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

# Configuration
COMPOSE_FILE="docker-compose-red.yml"
IMAGE_NAME="dronat-red"
CONTAINER_NAME="dronat-red-team"

# Functions
print_banner() {
    clear
    echo -e "${BOLD}${RED}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}       🚩 Dronat Red - Quick Start Deployment Script        ${NC}"
    echo -e "${BOLD}${RED}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}        Red Team Operations Environment - Automated Setup       ${NC}"
    echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_warning() {
    echo -e "${BOLD}${RED}⚠️  LEGAL WARNING ⚠️${NC}"
    echo -e "${YELLOW}This environment contains offensive security tools.${NC}"
    echo -e "${YELLOW}Use ONLY on systems you own or have explicit permission to test.${NC}"
    echo -e "${YELLOW}Users are responsible for compliance with all applicable laws.${NC}"
    echo ""
    read -p "I understand and agree to use this responsibly [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Deployment cancelled.${NC}"
        exit 1
    fi
}

check_requirements() {
    echo -e "${BLUE}🔍 Checking system requirements...${NC}"
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker not found. Please install Docker first.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker found: $(docker --version | cut -d' ' -f3)${NC}"
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose not found. Please install Docker Compose first.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker Compose found: $(docker-compose --version | cut -d' ' -f3)${NC}"
    
    # Check memory
    total_mem=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$total_mem" -lt 4000 ]; then
        echo -e "${YELLOW}⚠️  Warning: Low memory (${total_mem}MB). Recommend 8GB+ for optimal performance.${NC}"
    else
        echo -e "${GREEN}✅ Memory: ${total_mem}MB${NC}"
    fi
    
    # Check disk space
    available_space=$(df . | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt 20971520 ]; then  # 20GB in KB
        echo -e "${YELLOW}⚠️  Warning: Low disk space. Recommend 50GB+ for full environment.${NC}"
    else
        echo -e "${GREEN}✅ Disk space: Available${NC}"
    fi
    
    echo ""
}

show_deployment_options() {
    echo -e "${BOLD}${CYAN}🚀 Deployment Options:${NC}"
    echo ""
    echo -e "  ${YELLOW}1.${NC} 🔴 Basic Red Team Environment"
    echo -e "     • Core red team tools and frameworks"
    echo -e "     • Neovim, Python, basic C2 capabilities"
    echo -e "     • Resource usage: ~4GB RAM"
    echo ""
    echo -e "  ${YELLOW}2.${NC} 🚩 Standard Red Team Setup"
    echo -e "     • Core + Database + Cache + Basic C2"
    echo -e "     • PostgreSQL, Redis, Empire framework"
    echo -e "     • Resource usage: ~6GB RAM"
    echo ""
    echo -e "  ${YELLOW}3.${NC} 🏴‍☠️ Advanced Red Team Infrastructure"
    echo -e "     • All frameworks + Phishing + Monitoring"
    echo -e "     • Gophish, Evilginx2, ELK stack"
    echo -e "     • Resource usage: ~12GB RAM"
    echo ""
    echo -e "  ${YELLOW}4.${NC} 🛠️ Custom Configuration"
    echo -e "     • Choose specific components"
    echo -e "     • Tailored resource allocation"
    echo ""
    echo -e "  ${YELLOW}5.${NC} 📊 Environment Status & Management"
    echo -e "     • Check running containers"
    echo -e "     • View logs and troubleshoot"
    echo ""
    echo -e "  ${YELLOW}6.${NC} 🔄 Update & Rebuild"
    echo -e "     • Pull latest changes and rebuild"
    echo ""
    echo -e "  ${YELLOW}7.${NC} 🗑️ Stop & Cleanup"
    echo -e "     • Stop containers and cleanup resources"
    echo ""
    echo -e "  ${YELLOW}8.${NC} ❌ Exit"
    echo ""
}

deploy_basic() {
    echo -e "${CYAN}🔴 Deploying Basic Red Team Environment...${NC}"
    
    # Build the image
    echo -e "${BLUE}Building Dronat Red image...${NC}"
    docker build -f Dockerfile.red -t $IMAGE_NAME:latest .
    
    # Start basic environment
    echo -e "${BLUE}Starting basic red team container...${NC}"
    docker-compose -f $COMPOSE_FILE up -d dronat-red
    
    # Wait for container to be ready
    echo -e "${BLUE}Waiting for environment to be ready...${NC}"
    sleep 10
    
    echo -e "${GREEN}✅ Basic Red Team Environment deployed successfully!${NC}"
    echo -e "${CYAN}Access the environment with: docker exec -it $CONTAINER_NAME bash${NC}"
    echo -e "${CYAN}Or run the interactive menu: docker exec -it $CONTAINER_NAME ./menu-red.sh${NC}"
}

deploy_standard() {
    echo -e "${CYAN}🚩 Deploying Standard Red Team Setup...${NC}"
    
    # Build the image
    echo -e "${BLUE}Building Dronat Red image...${NC}"
    docker build -f Dockerfile.red -t $IMAGE_NAME:latest .
    
    # Start standard environment with database and cache
    echo -e "${BLUE}Starting standard red team infrastructure...${NC}"
    docker-compose -f $COMPOSE_FILE --profile database --profile cache up -d
    
    # Wait for services to be ready
    echo -e "${BLUE}Waiting for services to initialize...${NC}"
    sleep 20
    
    echo -e "${GREEN}✅ Standard Red Team Setup deployed successfully!${NC}"
    echo -e "${CYAN}Services available:${NC}"
    echo -e "  • Red Team Environment: docker exec -it $CONTAINER_NAME bash"
    echo -e "  • PostgreSQL Database: localhost:5432"
    echo -e "  • Redis Cache: localhost:6379"
}

deploy_advanced() {
    echo -e "${CYAN}🏴‍☠️ Deploying Advanced Red Team Infrastructure...${NC}"
    
    # Check if we have enough resources
    total_mem=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$total_mem" -lt 8000 ]; then
        echo -e "${YELLOW}⚠️  Warning: Advanced setup requires 8GB+ RAM. Current: ${total_mem}MB${NC}"
        read -p "Continue anyway? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    # Build the image
    echo -e "${BLUE}Building Dronat Red image...${NC}"
    docker build -f Dockerfile.red -t $IMAGE_NAME:latest .
    
    # Start full infrastructure
    echo -e "${BLUE}Starting advanced red team infrastructure...${NC}"
    docker-compose -f $COMPOSE_FILE \
        --profile database \
        --profile cache \
        --profile c2 \
        --profile phishing \
        --profile monitoring up -d
    
    # Wait for all services
    echo -e "${BLUE}Waiting for all services to initialize (this may take a few minutes)...${NC}"
    sleep 60
    
    echo -e "${GREEN}✅ Advanced Red Team Infrastructure deployed successfully!${NC}"
    echo -e "${CYAN}Full service stack available:${NC}"
    echo -e "  • Red Team Environment: docker exec -it $CONTAINER_NAME bash"
    echo -e "  • Empire C2: http://localhost:5000"
    echo -e "  • Covenant C2: https://localhost:7443"
    echo -e "  • Gophish: http://localhost:3333"
    echo -e "  • Elasticsearch: http://localhost:9200"
    echo -e "  • JupyterLab: http://localhost:8888"
}

deploy_custom() {
    echo -e "${CYAN}🛠️ Custom Configuration Setup${NC}"
    echo ""
    echo "Select components to deploy:"
    echo ""
    
    profiles=()
    
    # Database
    read -p "Include Database (PostgreSQL)? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        profiles+=("--profile" "database")
        echo -e "${GREEN}✓ Database selected${NC}"
    fi
    
    # Cache
    read -p "Include Cache (Redis)? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        profiles+=("--profile" "cache")
        echo -e "${GREEN}✓ Cache selected${NC}"
    fi
    
    # C2 Frameworks
    read -p "Include C2 Frameworks (Empire, Covenant)? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        profiles+=("--profile" "c2")
        echo -e "${GREEN}✓ C2 Frameworks selected${NC}"
    fi
    
    # Phishing
    read -p "Include Phishing Tools (Gophish, Evilginx2)? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        profiles+=("--profile" "phishing")
        echo -e "${GREEN}✓ Phishing Tools selected${NC}"
    fi
    
    # Monitoring
    read -p "Include Monitoring (ELK Stack)? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        profiles+=("--profile" "monitoring")
        echo -e "${GREEN}✓ Monitoring selected${NC}"
    fi
    
    # Build and deploy
    echo -e "${BLUE}Building Dronat Red image...${NC}"
    docker build -f Dockerfile.red -t $IMAGE_NAME:latest .
    
    echo -e "${BLUE}Starting custom red team configuration...${NC}"
    docker-compose -f $COMPOSE_FILE "${profiles[@]}" up -d
    
    echo -e "${GREEN}✅ Custom Red Team Configuration deployed!${NC}"
}

show_status() {
    echo -e "${CYAN}📊 Environment Status${NC}"
    echo ""
    
    # Check if containers are running
    if docker ps | grep -q $CONTAINER_NAME; then
        echo -e "${GREEN}✅ Dronat Red container is running${NC}"
        
        # Show container stats
        echo ""
        echo -e "${BLUE}Container Statistics:${NC}"
        docker stats --no-stream $CONTAINER_NAME
        
        # Show ports
        echo ""
        echo -e "${BLUE}Exposed Ports:${NC}"
        docker port $CONTAINER_NAME
        
        # Show logs (last 20 lines)
        echo ""
        echo -e "${BLUE}Recent Logs:${NC}"
        docker logs --tail 20 $CONTAINER_NAME
        
    else
        echo -e "${RED}❌ Dronat Red container is not running${NC}"
    fi
    
    # Show all related containers
    echo ""
    echo -e "${BLUE}All Dronat Red Containers:${NC}"
    docker ps -a | grep -E "(dronat-red|empire|covenant|gophish|postgres-red|redis-red)" || echo "No containers found"
}

update_rebuild() {
    echo -e "${CYAN}🔄 Updating and Rebuilding Dronat Red${NC}"
    
    # Stop existing containers
    echo -e "${BLUE}Stopping existing containers...${NC}"
    docker-compose -f $COMPOSE_FILE down
    
    # Pull latest changes (if in git repo)
    if [ -d ".git" ]; then
        echo -e "${BLUE}Pulling latest changes...${NC}"
        git pull origin main
    fi
    
    # Rebuild image
    echo -e "${BLUE}Rebuilding image...${NC}"
    docker build --no-cache -f Dockerfile.red -t $IMAGE_NAME:latest .
    
    echo -e "${GREEN}✅ Update and rebuild complete!${NC}"
    echo -e "${YELLOW}Use deployment options to start the updated environment.${NC}"
}

cleanup() {
    echo -e "${CYAN}🗑️ Cleanup Options${NC}"
    echo ""
    echo "1. Stop containers (keep data)"
    echo "2. Stop and remove containers (keep images and volumes)"
    echo "3. Full cleanup (remove everything including data)"
    echo "4. Cancel"
    echo ""
    
    read -p "Select cleanup option [1-4]: " cleanup_choice
    
    case $cleanup_choice in
        1)
            echo -e "${BLUE}Stopping containers...${NC}"
            docker-compose -f $COMPOSE_FILE stop
            echo -e "${GREEN}✅ Containers stopped${NC}"
            ;;
        2)
            echo -e "${BLUE}Stopping and removing containers...${NC}"
            docker-compose -f $COMPOSE_FILE down
            echo -e "${GREEN}✅ Containers removed${NC}"
            ;;
        3)
            echo -e "${RED}⚠️  This will delete ALL data including databases and volumes!${NC}"
            read -p "Are you sure? [y/N]: " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${BLUE}Performing full cleanup...${NC}"
                docker-compose -f $COMPOSE_FILE down -v --rmi all
                docker system prune -f
                echo -e "${GREEN}✅ Full cleanup complete${NC}"
            else
                echo -e "${YELLOW}Cleanup cancelled${NC}"
            fi
            ;;
        4)
            echo -e "${YELLOW}Cleanup cancelled${NC}"
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
}

# Main menu loop
main() {
    print_banner
    print_warning
    
    while true; do
        echo ""
        check_requirements
        show_deployment_options
        
        read -p "Select deployment option [1-8]: " choice
        
        case $choice in
            1)
                deploy_basic
                ;;
            2)
                deploy_standard
                ;;
            3)
                deploy_advanced
                ;;
            4)
                deploy_custom
                ;;
            5)
                show_status
                ;;
            6)
                update_rebuild
                ;;
            7)
                cleanup
                ;;
            8)
                echo -e "${GREEN}🚩 Thank you for using Dronat Red! Stay ethical! 🚩${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please select 1-8.${NC}"
                sleep 2
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
        print_banner
    done
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi