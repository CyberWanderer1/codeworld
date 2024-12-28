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

# Update package lists and upgrade installed packages
echo -e "${YELLOW}Updating and upgrading system packages...${NC}"
sudo apt update -y && sudo apt upgrade -y

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is already installed, skipping Docker installation.${NC}"
else
    # Install dependencies for Docker installation
    echo -e "${YELLOW}Installing required dependencies for Docker...${NC}"
    sudo apt install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common \
      lsb-release \
      gnupg2

    # Add Docker's official GPG key
    echo -e "${YELLOW}Adding Docker's official GPG key...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add Docker repository
    echo -e "${YELLOW}Adding Docker repository...${NC}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package lists to include Docker's repository
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update -y

    # Install Docker
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Check if Docker is installed successfully
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker installation failed!${NC}"
        exit 1
    else
        echo -e "${YELLOW}Docker is successfully installed!${NC}"
    fi
fi

# Check if Docker Compose is already installed
if command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose is already installed, skipping Docker Compose installation.${NC}"
else
    echo -e "${YELLOW}Docker Compose not found. Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${YELLOW}Docker Compose has been installed!${NC}"
fi

# Add current user to Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adding user to Docker group..."
    sudo groupadd docker
    sudo usermod -aG docker $USER
else
    echo "User is already in the Docker group."
fi

# Pull the Titan Docker image
docker pull nezha123/titan-edge

# Number of nodes to set up
NODE_COUNT=4  # Change this number to the number of nodes you want to set up

# Loop through each node and set it up
for ((i = 1; i <= NODE_COUNT; i++)); do
    NODE_DIR="$HOME/.titanedge_node$i"
    echo -e "${YELLOW}Setting up Node $i in $NODE_DIR...${NC}"

    # Create the directory for the node
    mkdir -p "$NODE_DIR"

    # Run the Titan Docker container for this node
    echo -e "${YELLOW}Running Titan Node $i...${NC}"
    docker run --network=host -d -v "$NODE_DIR:/root/.titanedge" nezha123/titan-edge 

    # Wait for the container to initialize (5 seconds delay)
    echo -e "${YELLOW}Waiting for Node $i to initialize...${NC}"
    sleep 5

    # Prompt for Titan identity code
    echo -e "${YELLOW}Enter Titan identity code for Node $i: ${NC}"
    read identity_code  # Read input from the user

    # Bind the identity code to the device
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
