# outputs

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.password_generator.repository_url
}

output "app_runner_service_arn" {
  description = "App Runner service ARN"
  value       = aws_apprunner_service.password_generator.service_arn
}

output "app_runner_service_url" {
  description = "App Runner service URL"
  value       = aws_apprunner_service.password_generator.service_url
}

output "application_url" {
  description = "Your application URL"
  value       = "https://${aws_apprunner_service.password_generator.service_url}"
}