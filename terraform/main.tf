# Simple AWS App Runner deployment

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ECR Repository
resource "aws_ecr_repository" "password_generator" {
  name = var.project_name
}

# IAM role for App Runner
resource "aws_iam_role" "apprunner_role" {
  name = "${var.project_name}-apprunner-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_policy" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# App Runner Service
resource "aws_apprunner_service" "password_generator" {
  service_name = var.project_name
  
  source_configuration {
    image_repository {
      image_configuration {
        port = "5000"
      }
      image_identifier      = "${aws_ecr_repository.password_generator.repository_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = false
  }
  
  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "0.5 GB"
  }
}