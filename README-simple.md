# Password Generator

A simple password generator app deployed on AWS.

## Quick Setup

1. **Setup AWS**:
   ```bash
   aws configure
   # Enter your AWS Access Key ID and Secret Access Key
   ```

2. **Setup GitHub Secrets** (for automatic deployment):
   - Go to your repo → Settings → Secrets → Actions
   - Add: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

3. **Deploy**:
   ```bash
   chmod +x deploy-simple.sh
   ./deploy-simple.sh
   ```

## What you need

- AWS Account
- AWS CLI installed
- Docker installed  
- Terraform installed

## Cost

~$5-15/month (only pay when people use this app)

## Files

- `app.py` - The password generator
- `terraform/` - AWS setup
- `.github/workflows/` - Auto deployment
- `deploy-simple.sh` - Manual deployment

## That's it!

Push code to `main` branch = automatic deployment
