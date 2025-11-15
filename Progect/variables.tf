variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_tf_url" {
  description = "GitHub Terraform repository URL"
  type        = string
}

variable "github_tf_branch" {
  description = "GitHub Terraform repository branch"
  type        = string
}

variable "github_main_branch" {
  description = "Main branch name"
  type        = string
  default     = "main"
}

variable "helm_chart_path" {
  description = "Шлях до Helm чарта"
  type        = string
  default     = "Progect/charts/django-app"
}