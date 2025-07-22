# Password Generator - DevOpsified

A production-ready, serverless password generator application with CI/CD pipeline and infrastructure as code. Deployed on AWS App Runner for maximum cost efficiency.

##  Quick Overview

- **Cost**: ~$8-20/month (usage-based serverless)
- **Performance**: Auto-scaling serverless containers
- **Deployment**: Fully automated CI/CD with GitHub Actions
- **Infrastructure**: Terraform for reproducible deployments
- **Security**: IAM roles, HTTPS, and best practices included

##  Tech Stack

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Python Flask
- **Infrastructure**: AWS App Runner, ECR
- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **Containerization**: Docker

##  Quick Start

1. **Fork this repository**
2. **Configure AWS credentials** in GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. **Push to main branch** → Automatic deployment!

##  Detailed Instructions

For complete setup instructions, configuration details, and troubleshooting, see:

**[USAGE.md](./USAGE.md) - Complete Usage Instructions**

##  Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Repo   │    │  GitHub Actions  │    │   AWS Cloud     │
│                 ───▶│                   ───▶                  │
│ - Source Code   │    │ - Build & Test   │    │ - ECR Registry  │
│ - Terraform     │    │ - Deploy to AWS  │    │ - App Runner    │
│ - CI/CD Config  │    │ - Auto Scaling   │    │ - Auto HTTPS    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🔧 Project Structure

```
password-generator-devops/
├── 📄 app.py                  # Flask application
├── 📄 Dockerfile              # Container configuration
├── 📄 requirements.txt        # Python dependencies
├── 🗂️ templates/
│   └── index.html             # Web interface
├── 🗂️ terraform/              # Infrastructure as Code
│   ├── main.tf                # AWS resources
│   ├── variables.tf           # Configuration variables
│   └── outputs.tf             # Deployment outputs
├── 🗂️ .github/workflows/      # CI/CD pipeline
│   └── ci-cd.yml              # GitHub Actions
├── 📄 deploy.sh               # Manual deployment script
├── 📄 cleanup.sh              # Cleanup script
├── 📄 USAGE.md                # Detailed instructions
└── 📄 README.md              
```

##  Features

### Application Features
-  Customizable password length (8-50 characters)
-  Character type selection (letters, numbers, symbols)
-  One-click copy to clipboard
-  Responsive web design
-  Real-time validation
-  Cross-browser compatibility

### DevOpsified
-  **Automated CI/CD** with GitHub Actions
-  **Infrastructure as Code** with Terraform
-  **Serverless deployment** on AWS App Runner
-  **Cost optimization** (~$8-20/month)
-  **Auto-scaling** and auto-pause
-  **HTTPS by default**
-  **Multi-platform Docker builds**
-  **Automated testing** and quality checks

##  Cost Breakdown

| Component | Cost | Notes |
|-----------|------|-------|
| **AWS App Runner** | $7-15/month | Usage-based, auto-pause when idle |
| **ECR Storage** | ~$0.10/month | Container image storage |
| **Data Transfer** | $1-3/month | Minimal for low traffic |
| **Total** | **$8-20/month** | Much cheaper than EKS ($150+/month) |

##  Deployment Options

### 1. Automatic (Recommended)
Push to `main` branch → GitHub Actions handles everything

### 2. Manual Deployment
```bash
# Make sure you have AWS CLI, Docker, and Terraform installed
./deploy.sh
```

### 3. Step-by-step Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

##  Security Features

-  **HTTPS by default** (App Runner managed certificates)
-  **IAM roles** with least privilege access
-  **No hardcoded secrets** (GitHub Secrets + Terraform)
-  **Container security** scanning
-  **Automated dependency updates**

##  Monitoring

- **Application Health**: Built-in App Runner health checks
- **Logs**: CloudWatch Logs integration
- **Metrics**: CPU, memory, and request metrics
- **Alerts**: Can be configured via CloudWatch

##  Local Development

```bash
# Clone repository
git clone <your-repo-url>
cd password-generator-devops

# Run locally with Python
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py

# Or run with Docker
docker build -t password-generator .
docker run -p 5000:5000 password-generator

# Open browser
open http://localhost:5000
```

##  Prerequisites

- AWS Account (Free tier compatible)
- GitHub Account
- AWS CLI installed and configured
- Docker installed (for local development)
- Terraform installed (for manual deployment)


## Acknowledgments

- Built with 💙 for cost-effective DevOps practices
- Optimized for AWS Free Tier and small-scale deployments
- Inspired by modern serverless architectures



**Ready to deploy? Check out [USAGE.md](./USAGE.md) for step-by-step instructions!**
