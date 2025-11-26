variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4" 
}

variable "github_username" {
  description = "GitHub username для Argo CD репозиторію"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_url" {
  description = "URL GitHub репозиторію"
  type        = string
}

variable "github_main_branch" {
  description = "Основна гілка GitHub репозиторію"
  type        = string
  default     = "main"
}

variable "helm_chart_path" {
  description = "Шлях до Helm чарта"
  type        = string
  default     = "Progect/charts/django-app"
}