
resource "kubernetes_ingress_v1" "plausible" {
  metadata {
    name      = "plausible-ingress"
    namespace = kubernetes_namespace.analytics.metadata[0].name
    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.certificate_issuer_name,
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true",
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true",
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP",
    }
  }

  spec {
    ingress_class_name = var.nginx_ingress_class

    tls {
      hosts       = ["plausible.chbrx.com"]
      secret_name = "plausible-cert"
    }

    rule {
      host = "plausible.chbrx.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.plausible.metadata[0].name
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
  }
}