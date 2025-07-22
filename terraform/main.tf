terraform {
  backend "s3" {
    bucket         = "password-gen-pro-bucket-1"
    key            = "password-generator/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
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

# ----------------------------------------
# ECR Repository
# ----------------------------------------
resource "aws_ecr_repository" "password_generator" {
  name = var.project_name

  lifecycle {
    prevent_destroy = false
  }
}

# Fetch the latest image digest (only if create_service=true)
data "aws_ecr_image" "latest" {
  count           = var.create_service ? 1 : 0
  repository_name = aws_ecr_repository.password_generator.name
  image_tag       = "latest"

  depends_on = [aws_ecr_repository.password_generator]
}

# ----------------------------------------
# IAM Role for App Runner
# ----------------------------------------
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

# ----------------------------------------
# App Runner Service (Created only when create_service=true)
# ----------------------------------------
resource "aws_apprunner_service" "password_generator" {
  count = var.create_service ? 1 : 0

  service_name = var.project_name

  source_configuration {
    image_repository {
      image_configuration {
        port = var.container_port
      }
      image_identifier      = "${aws_ecr_repository.password_generator.repository_url}@${data.aws_ecr_image.latest[0].image_digest}"
      image_repository_type = "ECR"
    }

    auto_deployments_enabled = false

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }
  }

  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "0.5 GB"
  }

  depends_on = [aws_iam_role_policy_attachment.apprunner_ecr_policy]
}
