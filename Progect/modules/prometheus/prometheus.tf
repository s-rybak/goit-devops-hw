resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = var.namespace
  version    = var.chart_version
  create_namespace = false

  depends_on = [
    kubernetes_namespace.prometheus
  ]

  values = [
    file("${path.module}/values.yaml")
  ]
}

