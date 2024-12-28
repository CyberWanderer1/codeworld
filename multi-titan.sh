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

# Number of nodes to create (adjust this number as needed)
NODE_COUNT=3

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed!${NC}"
    exit 1
fi

# Pull the Titan Docker image
docker pull nezha123/titan-edge

# Loop through to create and run multiple Titan nodes
for i in $(seq 1 $NODE_COUNT); do
    # Create unique directory for each node
    NODE_DIR="$HOME/.titanedge_node$i"
    if [ ! -d "$NODE_DIR" ]; then
        mkdir -p "$NODE_DIR"
    fi

    echo -e "${YELLOW}Setting up Node $i in $NODE_DIR...${NC}"

    # Run the Titan Docker container for this node
    docker run --network=host -d -v "$NODE_DIR:/root/.titanedge" nezha123/titan-edge

    # Wait for the node to initialize (adjust time if needed)
    echo -e "${YELLOW}Waiting for Node $i to initialize...${NC}"
    sleep 10

    # Prompt for Titan identity code
    echo -e "${YELLOW}Enter Titan identity code for Node $i: ${NC}"
    read identity_code  # Read input from the user

    # Bind the identity code to the device for this node
    docker run --rm -it -v "$NODE_DIR:/root/.titanedge" nezha123/titan-edge bind --hash="$identity_code" https://api-test1.container1.titannet.io/api/v2/device/binding

    echo -e "${GREEN}Node $i is successfully set up and bound!${NC}"
done

# Thank you message
echo "==================================="
echo -e "${BANNER}           CyberWanderer       ${NC}"
echo "==================================="
echo -e "${GREEN}    All $NODE_COUNT Titan nodes have been set up and bound!${NC}"
echo "==================================="
echo -e "${YELLOW}Telegram: https://t.me/anjumisamanjum${NC}"
echo -e "${YELLOW}Twitter: @theanjum1${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@CyberWanderer${NC}"
echo "==================================="
