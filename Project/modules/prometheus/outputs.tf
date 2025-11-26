output "prometheus_namespace" {
  description = "Kubernetes namespace де розгорнуто Prometheus"
  value       = kubernetes_namespace.prometheus.metadata[0].name
}

output "prometheus_service_name" {
  description = "Ім'я сервісу Prometheus"
  value       = helm_release.prometheus.name
}

output "prometheus_chart_version" {
  description = "Версія Helm chart Prometheus"
  value       = helm_release.prometheus.version
}
