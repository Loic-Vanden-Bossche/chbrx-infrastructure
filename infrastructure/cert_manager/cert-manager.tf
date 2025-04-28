resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.17.2"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({
      installCRDs = true
      extraArgs = [
        "--dns01-recursive-nameservers-only",
        "--dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53"
      ]
      global = {
        telemetry = {
          enabled = false
        }
      }
      prometheus = {
        enabled = false
      }
      webhook = {
        resources = {
          requests = {
            cpu    = "10m"
            memory = "64Mi"
          }
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
      }
      cainjector = {
        resources = {
          requests = {
            cpu    = "10m"
            memory = "64Mi"
          }
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
      }
    })
  ]
}