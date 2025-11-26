output "grafana_namespace" {
  description = "Kubernetes namespace де розгорнуто Grafana"
  value       = kubernetes_namespace.grafana.metadata[0].name
}

output "grafana_service_name" {
  description = "Ім'я сервісу Grafana"
  value       = helm_release.grafana.name
}

output "grafana_chart_version" {
  description = "Версія Helm chart Grafana"
  value       = helm_release.grafana.version
}

