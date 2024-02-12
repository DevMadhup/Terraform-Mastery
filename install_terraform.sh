#!/bin/bash

# Color variables for output
LIGHTGREEN='\033[1;32m'
NC='\033[0m'

# Download Terraform GPG Keys
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# SignIn using Downloaded GPG keys
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt update && sudo apt install terraform -y
echo -e "${LIGHTGREEN}Terraform Installed Successfully${NC}"
echo -e "Terrform version:${LIGHTGREEN} $(terraform --version) ${NC}"
