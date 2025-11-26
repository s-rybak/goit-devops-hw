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

output "eks_cluster_endpoint" {
  description = "EKS API endpoint for connecting to the cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS Worker Nodes"
  value       = module.eks.eks_node_role_arn
}
  
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider_url
}

# output "jenkins_release" {
#   value = module.jenkins.jenkins_release_name
# }

# output "jenkins_namespace" {
#   value = module.jenkins.jenkins_namespace
# }

# output "argo_cd_server_service" {
#   description = "Argo CD server service"
#   value       = module.argo_cd.argo_cd_server_service
# }

# output "prometheus_namespace" {
#   description = "Prometheus namespace"
#   value       = module.prometheus.prometheus_namespace
# }

# output "prometheus_server_url" {
#   description = "Prometheus server URL"
#   value       = module.prometheus.prometheus_server_url
# }

# output "grafana_namespace" {
#   description = "Grafana namespace"
#   value       = module.grafana.grafana_namespace
# }

# output "grafana_service_name" {
#   description = "Grafana service name"
#   value       = module.grafana.grafana_service_name
# }
