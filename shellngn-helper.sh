#!/bin/bash
# Shellngn Pro Management Helper Script

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CONTAINER_NAME="shellngn"
IMAGE_NAME="shellngn/pro"
PORT="8080"
DATA_DIR="$(pwd)/shellngn-data"

show_help() {
    echo "Shellngn Pro Management Helper"
    echo "=============================="
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start Shellngn Pro container"
    echo "  stop      Stop and remove Shellngn Pro container"  
    echo "  restart   Restart Shellngn Pro container"
    echo "  status    Show container status"
    echo "  logs      Show container logs"
    echo "  update    Pull latest image and restart"
    echo "  clean     Remove container and image"
    echo "  help      Show this help message"
    echo ""
    echo "Access: http://localhost:$PORT"
    echo "Data: $DATA_DIR"
}

start_shellngn() {
    echo -e "${BLUE}Starting Shellngn Pro...${NC}"
    
    # Create data directory if it doesn't exist
    mkdir -p "$DATA_DIR"
    
    # Check if container already exists
    if docker ps -a | grep -q "$CONTAINER_NAME"; then
        echo -e "${YELLOW}Container already exists. Removing old container...${NC}"
        docker stop "$CONTAINER_NAME" 2>/dev/null || true
        docker rm "$CONTAINER_NAME" 2>/dev/null || true
    fi
    
    # Pull latest image
    echo -e "${BLUE}Pulling latest Shellngn Pro image...${NC}"
    docker pull "$IMAGE_NAME"
    
    # Start container
    docker run -d \
        --name "$CONTAINER_NAME" \
        -p "$PORT:8080" \
        -v "$DATA_DIR:/data" \
        "$IMAGE_NAME"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Shellngn Pro started successfully!${NC}"
        echo -e "${BLUE}Access at: http://localhost:$PORT${NC}"
        echo -e "${BLUE}Data directory: $DATA_DIR${NC}"
    else
        echo -e "${RED}✗ Failed to start Shellngn Pro${NC}"
        exit 1
    fi
}

stop_shellngn() {
    echo -e "${BLUE}Stopping Shellngn Pro...${NC}"
    
    if docker ps | grep -q "$CONTAINER_NAME"; then
        docker stop "$CONTAINER_NAME"
        docker rm "$CONTAINER_NAME"
        echo -e "${GREEN}✓ Shellngn Pro stopped and removed${NC}"
    else
        echo -e "${YELLOW}Shellngn Pro is not running${NC}"
    fi
}

restart_shellngn() {
    echo -e "${BLUE}Restarting Shellngn Pro...${NC}"
    stop_shellngn
    start_shellngn
}

show_status() {
    echo -e "${BLUE}Shellngn Pro Status:${NC}"
    echo "===================="
    
    if docker ps | grep -q "$CONTAINER_NAME"; then
        echo -e "${GREEN}✓ Running${NC}"
        echo "Container ID: $(docker ps | grep $CONTAINER_NAME | awk '{print $1}')"
        echo "Access URL: http://localhost:$PORT"
        echo "Data Directory: $DATA_DIR"
        echo ""
        echo "Container Details:"
        docker ps | grep "$CONTAINER_NAME"
    else
        echo -e "${YELLOW}✗ Not running${NC}"
        
        if docker ps -a | grep -q "$CONTAINER_NAME"; then
            echo "Container exists but is stopped."
            echo "Use '$0 start' to start it."
        else
            echo "Container does not exist."
            echo "Use '$0 start' to create and start it."
        fi
    fi
}

show_logs() {
    echo -e "${BLUE}Shellngn Pro Logs:${NC}"
    echo "=================="
    
    if docker ps -a | grep -q "$CONTAINER_NAME"; then
        docker logs "$CONTAINER_NAME"
    else
        echo -e "${YELLOW}Container does not exist${NC}"
    fi
}

update_shellngn() {
    echo -e "${BLUE}Updating Shellngn Pro...${NC}"
    
    # Pull latest image
    docker pull "$IMAGE_NAME"
    
    # Restart if running
    if docker ps | grep -q "$CONTAINER_NAME"; then
        restart_shellngn
    else
        echo -e "${GREEN}✓ Image updated. Use '$0 start' to run with latest version.${NC}"
    fi
}

clean_shellngn() {
    echo -e "${YELLOW}Cleaning up Shellngn Pro...${NC}"
    
    # Stop and remove container
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    
    # Remove image
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
    
    echo -e "${GREEN}✓ Shellngn Pro cleaned up${NC}"
    echo -e "${BLUE}Note: Data directory $DATA_DIR was preserved${NC}"
}

# Main script logic
case "${1:-help}" in
    start)
        start_shellngn
        ;;
    stop)
        stop_shellngn
        ;;
    restart)
        restart_shellngn
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    update)
        update_shellngn
        ;;
    clean)
        clean_shellngn
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac