variable "namespace" {
  description = "Kubernetes namespace для Prometheus"
  type        = string
  default     = "prometheus"
}

variable "chart_version" {
  description = "Версія Helm chart для Prometheus"
  type        = string
  default     = "25.8.0"
}