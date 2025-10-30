# Загальне виведення ресурсів Terraform.
output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  value       = module.s3_backend.dynamodb_table_name
}

# Виходи з модуля ECR
output "ecr_repository_url" {
  description = "URL репозиторію ECR"
  value       = module.ecr.ecr_repository_url
}

output "ecr_repository_arn" {
  description = "ARN репозиторію ECR"
  value       = module.ecr.ecr_repository_arn
}

output "ecr_repository_name" {
  description = "Ім'я репозиторію ECR"
  value       = module.ecr.ecr_repository_name
}
