# Quick Setup Guide

## 🚀 What You Need to Configure

### 1. **AWS Account Setup**
```bash
# Install AWS CLI and configure
aws configure
```
Enter these when prompted:
- **AWS Access Key ID**: `AKIAXXXXXXXXXXXXX` (from AWS Console)
- **AWS Secret Access Key**: `xxxxxxxxxxxxxxxxxxxxx` (from AWS Console)  
- **Default region**: `us-east-1` (or your preferred region)
- **Default output format**: `json`

### 2. **GitHub Repository Secrets**
Go to: **Your Repo → Settings → Secrets and variables → Actions**

Add these 2 secrets:
| Secret Name | Value |
|-------------|--------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key |

### 3. **Project Name (Optional)**
If you want to change the project name from "password-generator":

**File: `.github/workflows/ci-cd.yml` (Line 10)**
```yaml
env:
  PROJECT_NAME: your-new-name  # Change this
  AWS_REGION: us-east-1
```

**File: `terraform/variables.tf` (Line 3)**
```hcl
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "your-new-name"  # Change this
}
```

**File: `deploy.sh` (Line 15)**
```bash
PROJECT_NAME="your-new-name"  # Change this
```

**File: `cleanup.sh` (Line 14)**
```bash
PROJECT_NAME="your-new-name"  # Change this
```

### 4. **AWS Region (Optional)**
If you want to use a different region than `us-east-1`:

**File: `.github/workflows/ci-cd.yml` (Line 11)**
```yaml
env:
  PROJECT_NAME: password-generator
  AWS_REGION: your-region  # Change this (e.g., eu-west-1)
```

**File: `terraform/variables.tf` (Line 8)**
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "your-region"  # Change this
}
```

**File: `deploy.sh` (Line 16)**
```bash
AWS_REGION="your-region"  # Change this
```

## 🎯 That's It!

### **For Automatic Deployment:**
1. Setup AWS credentials in GitHub Secrets
2. Push code to `main` branch
3. GitHub Actions does everything automatically

### **For Manual Deployment:**
1. Setup AWS CLI locally
2. Run: `./deploy.sh`

## 📋 Summary of Changes

| What to Change | Where | Why |
|----------------|-------|-----|
| **AWS Credentials** | GitHub Secrets | For deployment access |
| **Project Name** | 4 files (optional) | Custom naming |
| **AWS Region** | 3 files (optional) | Different region |

## 🔧 Prerequisites

- ✅ AWS Account
- ✅ GitHub Account  
- ✅ AWS CLI installed (for manual deployment)
- ✅ Docker installed (for manual deployment)
- ✅ Terraform installed (for manual deployment)

## 💡 Quick Start

1. **Fork this repo**
2. **Add AWS secrets** to your GitHub repo
3. **Push to main branch** 
4. **Done!** Your app will be deployed automatically

**Cost**: ~$5-15/month (only when people use your app)
