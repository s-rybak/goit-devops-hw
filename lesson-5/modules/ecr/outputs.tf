# Виведення URL репозиторію ECR.
output "ecr_repository_url" {
  description = "URL репозиторію ECR"
  value       = aws_ecr_repository.repository.repository_url
}

# Виведення ARN репозиторію ECR
output "ecr_repository_arn" {
  description = "ARN репозиторію ECR"
  value       = aws_ecr_repository.repository.arn
}

# Виведення імені репозиторію ECR
output "ecr_repository_name" {
  description = "Ім'я репозиторію ECR"
  value       = aws_ecr_repository.repository.name
}

# Виведення registry ID
output "ecr_registry_id" {
  description = "ID реєстру ECR"
  value       = aws_ecr_repository.repository.registry_id
}