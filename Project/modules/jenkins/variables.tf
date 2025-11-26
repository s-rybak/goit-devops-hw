variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for EKS"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider for EKS"
  type        = string
}

variable "jenkins_admin_password" {
  type        = string
  description = "Jenkins admin password"
  sensitive   = true
}

variable "github_url" {
  type        = string
  description = "GitHub URL"
  default     = "https://github.com/AndriyDmitriv/infra.git"
}

variable "github_main_branch" {
  type        = string
  description = "GitHub main branch"
  default     = "main"
}

variable "github_username" {
  type        = string
  description = "GitHub username for Jenkins credentials"
  sensitive   = true
}

variable "github_pat" {
  type        = string
  description = "GitHub Personal Access Token for Jenkins credentials"
  sensitive   = true
}