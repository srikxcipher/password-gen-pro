#!/bin/bash
# Deployment script for Password Generator

set -e

echo "Deploying Password Generator..."

# Check prerequisites
command -v aws >/dev/null 2>&1 || { echo "AWS CLI required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "Terraform required"; exit 1; }

# Check AWS credentials
aws sts get-caller-identity >/dev/null 2>&1 || { echo "AWS credentials not configured"; exit 1; }

# Deploy infrastructure
cd terraform
terraform init
terraform apply -auto-approve

# Get outputs
ECR_URL=$(terraform output -raw ecr_repository_url)
SERVICE_ARN=$(terraform output -raw app_runner_service_arn)
APP_URL=$(terraform output -raw application_url)

cd ..

# Build and push Docker image
echo "Building Docker image..."
docker build -t password-generator .

echo "Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL

echo "Pushing to ECR..."
docker tag password-generator:latest $ECR_URL:latest
docker push $ECR_URL:latest

# Deploy to App Runner
echo "Deploying to App Runner..."
aws apprunner start-deployment --service-arn $SERVICE_ARN --region us-east-1

echo ""
echo "Deployment complete! ✔️"
echo "Your app: $APP_URL"
echo ""
