#!/bin/bash

# Define color codes
INFO='\033[0;36m'   # Cyan
BANNER='\033[0;35m' # Magenta
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'        # No Color

# Display social details and channel information
echo "==================================="
echo -e "${BANNER}           CyberWanderer       ${NC}"
echo "==================================="
echo -e "${YELLOW}Telegram: https://t.me/anjumisamanjum${NC}"
echo -e "${YELLOW}Twitter: @theanjum1${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@CyberWanderer${NC}"
echo "==================================="

# Update the package list
sudo apt update

# Check if Docker is installed, if not, install Docker
if ! command -v docker &> /dev/null; then
    echo -e "${WARNING}Docker not found. Installing Docker...${NC}"
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo -e "${SUCCESS}Docker installed successfully.${NC}"
else
    echo -e "${SUCCESS}Docker is already installed.${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${INFO}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${SUCCESS}Docker Compose installed successfully. Version: $(docker-compose --version)${NC}"
else
    echo -e "${SUCCESS}Docker Compose is already installed.${NC}"
fi

# Start the Docker container
echo -e "${INFO}Make sure to claim the Faucet before starting the container.${NC}"
read -p "Enter your EVM PRIVATE KEY: " YOUR_PRIVATE_KEY

if [ -z "$YOUR_PRIVATE_KEY" ]; then
    echo -e "${ERROR}Private Key is required to proceed. Exiting.${NC}"
    exit 1
fi

docker run -d -e PRIVATE_KEY=$YOUR_PRIVATE_KEY --name glacier-verifier docker.io/glaciernetwork/glacier-verifier:v0.0.3

# Display thank you message
echo "==================================="
echo -e "${BANNER}           CyberWanderer       ${NC}"
echo "==================================="
echo -e "${SUCCESS}    Thanks for using this script!${NC}"
echo "==================================="
echo -e "${YELLOW}Telegram: https://t.me/anjumisamanjum${NC}"
echo -e "${YELLOW}Twitter: @theanjum1${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@CyberWanderer${NC}"
echo "==================================="
