#!/bin/bash

# Define color variables
GREEN="\033[0;32m"     # Green
YELLOW="\033[1;33m"    # Bright Yellow
RED="\033[0;31m"       # Red
NC="\033[0m"           # No Color

# Display social details and channel information
echo "==================================="
echo -e "${BANNER}           CyberWanderer       ${NC}"
echo "==================================="
echo -e "${YELLOW}Telegram: https://t.me/anjumisamanjum${NC}"
echo -e "${YELLOW}Twitter: @theanjum1${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@CyberWanderer${NC}"
echo "==================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose is not installed. Please install it first.${NC}"
    exit 1
fi

# Pull the Titan Docker image
echo -e "${YELLOW}Pulling the Titan Docker image...${NC}"
docker pull nezha123/titan-edge

# Number of nodes to run
NODE_COUNT=4

# Loop to create and run multiple nodes
for ((i = 1; i <= NODE_COUNT; i++)); do
    NODE_DIR="$HOME/.titanedge_node$i"
    echo -e "${YELLOW}Setting up Node $i in $NODE_DIR...${NC}"
    
    # Create a unique directory for the node
    mkdir -p "$NODE_DIR"
    
    # Run the Titan Docker container for the node
    echo -e "${YELLOW}Running Titan Node $i...${NC}"
    docker run --network=host -d \
        --name "titan_node$i" \
        -v "$NODE_DIR:/root/.titanedge" \
        nezha123/titan-edge
    
    # Prompt for Titan identity code for binding
    echo -e "${YELLOW}Enter the Titan identity code for Node $i: ${NC}"
    read identity_code
    
    # Bind the node with the provided identity code
    docker run --rm -it \
        -v "$NODE_DIR:/root/.titanedge" \
        nezha123/titan-edge bind --hash="$identity_code" https://api-test1.container1.titannet.io/api/v2/device/binding
done

# Completion message
echo "==================================="
echo -e "${GREEN}    All $NODE_COUNT Titan nodes have been set up and bound!${NC}"
echo "==================================="
echo -e "${YELLOW}Thanks for using this script. For any support, join: https://t.me/anjumisamanjum${NC}"
echo "==================================="
