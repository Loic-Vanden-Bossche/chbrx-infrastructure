resource "kubernetes_manifest" "letsencrypt_production_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-production"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.email
        privateKeySecretRef = {
          name = "letsencrypt-production"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = var.nginx_ingress_class
              }
            }
          }
        ]
      }
    }
  }
}