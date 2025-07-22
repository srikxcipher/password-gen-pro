# Password Generator Project - Usage Instructions

A cost-optimized, serverless password generator application deployed on AWS App Runner.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [AWS Configuration](#aws-configuration)
4. [GitHub Actions Setup](#github-actions-setup)
5. [Local Development](#local-development)
6. [Deployment Options](#deployment-options)
7. [Configuration Files](#configuration-files)
8. [Troubleshooting](#troubleshooting)
9. [Cost Optimization](#cost-optimization)
10. [Security Best Practices](#security-best-practices)

## Prerequisites

Before you begin, ensure you have the following installed:

- **AWS CLI** (v2.0 or later)
- **Docker** (v20.0 or later)
- **Terraform** (v1.0 or later)
- **Python** (v3.8 or later)
- **Git**
- **A GitHub account**
- **An AWS account**

### Installation Commands

```bash
# Install AWS CLI (Linux/macOS)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Docker (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install Python dependencies
pip install -r requirements.txt
```

## Initial Setup

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd password-generator-devops
```

### 2. Make Scripts Executable

```bash
chmod +x deploy.sh
chmod +x cleanup.sh
```

## AWS Configuration

### 1. Create AWS Account and User

1. **Sign up for AWS Account**: Go to https://aws.amazon.com/
2. **Create IAM User**:
   - Go to AWS Console → IAM → Users → Add User
   - Username: `password-generator-deployer`
   - Access type: Programmatic access
   - Attach policies:
     - `AmazonEC2ContainerRegistryFullAccess`
     - `AppRunnerFullAccess`
     - `IAMFullAccess` (for creating service roles)
     - `CloudFormationFullAccess`

### 2. Configure AWS CLI

```bash
aws configure
```

Enter your credentials:
```
AWS Access Key ID: YOUR_ACCESS_KEY_HERE
AWS Secret Access Key: YOUR_SECRET_KEY_HERE
Default region name: us-east-1
Default output format: json
```

### 3. Verify AWS Configuration

```bash
aws sts get-caller-identity
```

This should return your AWS account details.

## GitHub Actions Setup

### 1. Fork/Create Repository

1. Fork this repository or create a new one
2. Clone your repository locally

### 2. Set up GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add the following **Repository Secrets**:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |

### 3. Configure Workflow Permissions

1. Go to Settings → Actions → General
2. Set "Workflow permissions" to: **Read and write permissions**
3. Allow GitHub Actions to create and approve pull requests

## Local Development

### 1. Set up Python Environment

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Linux/macOS:
source venv/bin/activate
# On Windows:
# venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Run Application Locally

```bash
# Start the Flask application
python app.py

# Or using Docker
docker build -t password-generator .
docker run -p 5000:5000 password-generator
```

### 3. Test the Application

Open your browser and go to:
- **Local**: http://localhost:5000
- **Test password generation**: Try different options on the web interface

## Deployment Options

### Option 1: Automated Deployment (Recommended)

**Using GitHub Actions (Automatic)**:
1. Push code to `main` branch
2. GitHub Actions will automatically:
   - Run tests
   - Build Docker image
   - Deploy to AWS App Runner
   - Provide deployment URL

### Option 2: Manual Deployment

**Using the deployment script**:
```bash
./deploy.sh
```

This script will:
- Check prerequisites
- Initialize Terraform
- Show deployment plan
- Deploy infrastructure
- Build and push Docker image
- Trigger App Runner deployment

### Option 3: Manual Terraform Commands

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply

# Get outputs
terraform output
```

## Configuration Files

### Key Files to Modify

#### 1. `terraform/variables.tf`
```hcl
variable "project_name" {
  default = "your-project-name" 
}

variable "aws_region" {
  default = "us-east-1"  # Change to your preferred region
}
```

#### 2. `terraform/main.tf`
- **ECR Repository Name**: Automatically uses `var.project_name`
- **App Runner Configuration**: Modify CPU/Memory if needed:

```hcl
instance_configuration {
  cpu    = "0.25 vCPU"  # Options: 0.25, 0.5, 1, 2 vCPU
  memory = "0.5 GB"     # Options: 0.5, 1, 2, 3, 4 GB
}
```

#### 3. `.github/workflows/ci-cd.yml`
```yaml
env:
  PROJECT_NAME: password-generator 
  AWS_REGION: us-east-1            
```

#### 4. `app.py`
- **Port Configuration**: Default is 5000 (App Runner compatible)
- **Flask Settings**: Modify as needed for your requirements


## Troubleshooting

### Common Issues and Solutions

#### 1. AWS Authentication Errors
```bash
# Error: Unable to locate credentials
# Solution: Run aws configure and enter your credentials
aws configure
```

#### 2. Docker Permission Issues
```bash
# Error: permission denied while trying to connect to Docker
# Solution: Add user to docker group
sudo usermod -aG docker $USER
# Logout and login again
```

#### 3. Terraform State Issues
```bash
# Error: State file locked
# Solution: Force unlock (use carefully)
cd terraform
terraform force-unlock <LOCK_ID>
```

#### 4. App Runner Deployment Fails
```bash
# Check App Runner logs
aws logs describe-log-groups --log-group-name-prefix "/aws/apprunner"

# Check service status
aws apprunner describe-service --service-arn <SERVICE_ARN>
```

#### 5. ECR Push Permission Denied
```bash
# Re-authenticate with ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ECR_URL>
```

### Debugging Commands

```bash
# Check AWS CLI configuration
aws configure list

# Verify Terraform state
cd terraform && terraform show

# Check Docker images
docker images

# View container logs
docker logs <container-name>

# Test application health
curl -f http://localhost:5000/
```

##  Cost Optimization

### Current Cost Breakdown

| Service | Configuration | Estimated Monthly Cost |
|---------|---------------|----------------------|
| **App Runner** | 0.25 vCPU + 0.5 GB | $7-15 (usage-based) |
| **ECR Storage** | ~100MB image | ~$0.10 |
| **Data Transfer** | Low traffic | ~$1-3 |
| **Total** | | **$8-20/month** |

### Cost Reduction Tips

1. **Use Spot Instances** (if switching to EC2):
   ```hcl
   # Uncomment EC2 configuration in main.tf for even lower costs
   instance_type = "t2.micro"  # Free tier eligible
   ```

2. **Optimize Container Size**:
   ```dockerfile
   # Use multi-stage builds to reduce image size
   FROM python:3.11-alpine  # Smaller base image
   ```

3. **Set App Runner Auto-Pause**:
   - App Runner automatically pauses when not in use
   - You only pay for active processing time

4. **Monitor Usage**:
   ```bash
   # Check AWS costs
   aws ce get-cost-and-usage --time-period Start=2025-01-01,End=2025-01-31 --granularity MONTHLY --metrics BlendedCost
   ```

## Security Best Practices

### 1. AWS Security

-  **Use IAM roles with minimal permissions**
-  **Enable AWS CloudTrail for auditing**
-  **Use AWS Secrets Manager for sensitive data**
-  **Enable VPC Flow Logs if using EC2**

### 2. Application Security

-  **Use HTTPS in production** (App Runner provides this automatically)
-  **Implement rate limiting**
-  **Add input validation**
-  **Use environment variables for secrets**

### 3. GitHub Security

-  **Never commit AWS credentials to code**
-  **Use GitHub Secrets for sensitive data**
-  **Enable branch protection rules**
-  **Require pull request reviews**

## Monitoring and Maintenance

### Health Checks

```bash
# Check application health
curl -f https://your-app-url.region.awsapprunner.com/

# Monitor App Runner metrics
aws apprunner describe-service --service-arn <SERVICE_ARN>
```

### Log Monitoring

```bash
# View App Runner logs
aws logs describe-log-streams --log-group-name "/aws/apprunner/your-service/application"
```

### Updates and Maintenance

1. **Application Updates**: Push to main branch (auto-deploys)
2. **Infrastructure Updates**: Modify Terraform files and run `terraform apply`
3. **Security Updates**: Regularly update base Docker images

### Backup Strategy

```bash
# Backup Terraform state
cd terraform
terraform state pull > backup-$(date +%Y%m%d).tfstate
```

## Support and Resources

### Useful Links

- **AWS App Runner Documentation**: https://docs.aws.amazon.com/apprunner/
- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/
- **Docker Best Practices**: https://docs.docker.com/develop/dev-best-practices/
- **GitHub Actions Documentation**: https://docs.github.com/en/actions

### Getting Help

1. **Issues**: Create an issue in the GitHub repository
2. **AWS Support**: Use AWS Support Center for infrastructure issues
3. **Community**: Stack Overflow with tags `aws-app-runner`, `terraform`, `flask`

---

## Quick Start Summary

1. **Clone repository** and make scripts executable
2. **Configure AWS CLI** with your credentials
3. **Set GitHub Secrets** (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
4. **Push to main branch** or run `./deploy.sh`
5. **Access your application** at the provided App Runner URL

**Total setup time**: ~15-30 minutes  
**Monthly cost**: ~$8-20 (usage-based)  
**Maintenance**: Minimal (serverless auto-scaling)

---

