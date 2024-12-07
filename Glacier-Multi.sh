#!/bin/bash

# Define color codes for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'  # No color

# Display social details and channel information
echo "==================================="
echo -e "${BANNER}           CyberWanderer       ${NC}"
echo "==================================="
echo -e "${YELLOW}Telegram: https://t.me/anjumisamanjum${NC}"
echo -e "${YELLOW}Twitter: @theanjum1${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@CyberWanderer${NC}"
echo "==================================="

# Loop to create containers interactively
for i in {1..3}; do  # Adjust the range as needed
    container_name="nillion-verifier$i"
    volume_path="./nillion/verifier$i"

    # Check if a container with the same name already exists
    if docker ps -a --format "{{.Names}}" | grep -q "^$container_name\$"; then
        echo -e "${YELLOW}Container $container_name already exists. Skipping creation.${NC}"
    else
        # Prompt for the private key
        read -p "Enter the private key for $container_name: " private_key

        # Create and start the container
        echo -e "${GREEN}Creating and starting container $container_name...${NC}"
        docker run -d -v "$volume_path:/var/tmp" --name "$container_name" nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com" --private-key "$private_key"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Container $container_name created and started successfully.${NC}"
        else
            echo -e "${RED}Failed to create and start container $container_name.${NC}"
        fi
    fi
done

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
