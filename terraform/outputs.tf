output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.password_generator.repository_url
}

output "app_runner_service_arn" {
  description = "App Runner service ARN"
  value       = try(aws_apprunner_service.password_generator[0].arn, "")
}

output "app_runner_service_url" {
  description = "App Runner service URL"
  value       = try(aws_apprunner_service.password_generator[0].service_url, "")
}

output "application_url" {
  description = "Your application URL"
  value       = try("https://${aws_apprunner_service.password_generator[0].service_url}", "")
}
