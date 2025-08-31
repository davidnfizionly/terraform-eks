resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "65.5.0"

  create_namespace = true

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
}
