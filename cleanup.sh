#!/bin/bash
# cleanup script - destroys all AWS resources

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
PROJECT_NAME="password-generator"

echo -e "${BLUE}Starting cleanup process${NC}"
echo "================================================"

# Warning
echo -e "${RED}  WARNING: This will destroy ALL infrastructure!${NC}"
echo -e "${YELLOW} Are you sure? Type 'DELETE' to confirm:${NC}"
read -r confirmation
if [[ "$confirmation" != "DELETE" ]]; then
    echo -e "${GREEN} Cleanup cancelled${NC}"
    exit 0
fi

# Navigate to terraform directory
cd terraform

# Check if state exists
if [ ! -f "terraform.tfstate" ]; then
    echo -e "${YELLOW}ℹ  No Terraform state found${NC}"
    exit 0
fi

# Get ECR URL before destruction
ECR_URL=$(terraform output -raw ecr_repository_url 2>/dev/null || echo "")

# Destroy infrastructure
echo -e "${YELLOW} Destroying infrastructure...${NC}"
terraform init -quiet
terraform destroy -auto-approve

echo ""
echo -e "${GREEN} Cleanup completed!${NC}"
echo -e "${GREEN} No more AWS charges${NC}"
echo ""
echo -e "${BLUE} To remove Docker images:${NC}"
echo "docker rmi ${PROJECT_NAME}:latest"
if [ ! -z "$ECR_URL" ]; then
    echo "docker rmi ${ECR_URL}:latest"
fi
echo "docker system prune -f"
