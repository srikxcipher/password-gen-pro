#!/bin/bash
set -e

# Path where your Terraform configuration files are located
TF_DIR="$(dirname "$0")/terraform"

cd "$TF_DIR"

PROJECT_NAME="password-generator"
AWS_REGION="us-east-1"

echo "=========================================="
echo "Deploying $PROJECT_NAME ..."
echo "=========================================="

# Step 1: Terraform init
echo "[Step 1] Initializing Terraform..."
terraform init -input=false

# Step 2: Create ECR + IAM roles
echo "[Step 2] Creating ECR repository and IAM role..."
terraform apply -auto-approve -var="create_service=false"

# Get ECR Repository URL
ECR_URL=$(terraform output -raw ecr_repository_url)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "ECR Repository URL: $ECR_URL"

echo "[Step 3] Building and pushing Docker image..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

pushd ..
docker build -t $PROJECT_NAME .
docker tag $PROJECT_NAME:latest $ECR_URL:latest
docker push $ECR_URL:latest
popd

# Step 4: Deploy App Runner service
echo "[Step 4] Deploying App Runner service..."
terraform apply -auto-approve -var="create_service=true"

# Fetch Application URL
APP_URL=$(terraform output -raw application_url)
echo "=========================================="
echo "Deployment complete! Your app is live at:"
echo "$APP_URL"
echo "=========================================="
