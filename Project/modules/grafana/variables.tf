variable "namespace" {
  description = "Kubernetes namespace для Grafana"
  type        = string
  default     = "grafana"
}

variable "chart_version" {
  description = "Версія Helm chart для Grafana"
  type        = string
  default     = "7.0.0"
}

variable "grafana_admin_password" {
  type        = string
  description = "Grafana admin password"
  sensitive   = true
}

variable "prometheus_url" {
  type        = string
  description = "Prometheus URL для data source"
  default     = "http://prometheus-server.prometheus.svc.cluster.local"
}

