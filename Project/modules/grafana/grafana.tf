resource "kubernetes_namespace" "grafana" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.namespace
  version    = var.chart_version
  create_namespace = false

  depends_on = [
    kubernetes_namespace.grafana
  ]

  values = [
    templatefile("${path.module}/values.yaml", {
      grafana_admin_password = var.grafana_admin_password
      prometheus_url         = var.prometheus_url
    })
  ]
}

