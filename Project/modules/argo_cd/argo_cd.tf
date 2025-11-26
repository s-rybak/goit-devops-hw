resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  create_namespace = true
  timeout          = 600
  wait             = true
  wait_for_jobs    = true
}

resource "helm_release" "argo_apps" {
  name       = "${var.name}-apps"
  chart      = "${path.module}/charts"
  namespace  = var.namespace
  create_namespace = false

  values = [
    templatefile("${path.module}/charts/values.yaml", {
      github_url         = var.github_url
      github_username    = var.github_username
      github_pat         = var.github_pat
      github_main_branch = var.github_main_branch
      helm_chart_path    = var.helm_chart_path
    })
  ]
  depends_on = [helm_release.argo_cd]
}

