#!/bin/bash
# Deployment script for Password Generator - Cost Optimized Version
# This script automates the deployment echo -e "${YELLOW} Estimated monthly cost: \$5-15 (usage-based)${NC}"rocess to AWS App Runner

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="password-generator"
AWS_REGION="us-east-1"

echo -e "${BLUE} Starting Password Generator Deployment${NC}"
echo "================================================"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED} AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED} Docker is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED} Terraform is not installed. Please install it first.${NC}"
    exit 1
fi

# Check AWS credentials
echo -e "${YELLOW} Checking AWS credentials...${NC}"
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED} AWS credentials not configured. Please run 'aws configure' first.${NC}"
    exit 1
fi
echo -e "${GREEN} AWS credentials verified${NC}"

# Navigate to terraform directory
cd terraform

# Initialize Terraform
echo -e "${YELLOW} Initializing Terraform...${NC}"
terraform init

# Plan the deployment
echo -e "${YELLOW} Planning Terraform deployment...${NC}"
terraform plan

# Ask for confirmation
echo -e "${YELLOW} Do you want to proceed with the deployment? (y/N):${NC}"
read -r response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${RED} Deployment cancelled.${NC}"
    exit 0
fi

# Apply Terraform configuration
echo -e "${YELLOW} Deploying infrastructure...${NC}"
terraform apply -auto-approve

# Get ECR repository URL
ECR_URL=$(terraform output -raw ecr_repository_url)
echo -e "${GREEN} Infrastructure deployed successfully!${NC}"
echo -e "${BLUE} ECR Repository: ${ECR_URL}${NC}"

# Navigate back to project root
cd ..

# Build Docker image
echo -e "${YELLOW} Building Docker image...${NC}"
docker build -t ${PROJECT_NAME}:latest .

# Login to ECR
echo -e "${YELLOW} Logging into ECR...${NC}"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}

# Tag the image for ECR
echo -e "${YELLOW} Tagging Docker image...${NC}"
docker tag ${PROJECT_NAME}:latest ${ECR_URL}:latest

# Push the image to ECR
echo -e "${YELLOW} Pushing image to ECR...${NC}"
docker push ${ECR_URL}:latest

# Get App Runner service ARN
cd terraform
SERVICE_ARN=$(terraform output -raw app_runner_service_arn)
APP_URL=$(terraform output -raw application_url)

# Trigger deployment in App Runner
echo -e "${YELLOW} Triggering App Runner deployment...${NC}"
aws apprunner start-deployment --service-arn ${SERVICE_ARN} --region ${AWS_REGION}

# Wait for deployment to complete
echo -e "${YELLOW} Waiting for deployment to complete...${NC}"
sleep 30  # Give it some time to start

# Check service status
STATUS=$(aws apprunner describe-service --service-arn ${SERVICE_ARN} --region ${AWS_REGION} --query 'Service.Status' --output text)
echo -e "${BLUE} Service Status: ${STATUS}${NC}"

echo ""
echo -e "${GREEN} Deployment completed successfully!${NC}"
echo "================================================"
echo -e "${BLUE} Application URL: ${APP_URL}${NC}"
echo -e "${BLUE} Service ARN: ${SERVICE_ARN}${NC}"
echo ""
echo -e "${YELLOW} To check service status:${NC}"
echo "aws apprunner describe-service --service-arn ${SERVICE_ARN} --region ${AWS_REGION}"
echo ""
echo -e "${YELLOW} Estimated monthly cost: \$8-20 (usage-based)${NC}"
echo ""
echo -e "${GREEN} Your password generator is now live!${NC}"
