variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "password-generator"
}

variable "container_port" {
  default = "5000"
}

# For two-phase deployments:
# false = only ECR + IAM (no App Runner)
# true  = deploy App Runner using the existing image in ECR
variable "create_service" {
  default     = false
  type        = bool
  description = "Set to true after pushing the Docker image to ECR."
}
