resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  values = [
    file("values/cert-manager.yaml")
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }
}