resource "kubernetes_config_map" "nginx_headers" {
  metadata {
    name      = "nginx-headers"
    namespace = "ingress-nginx"
  }

  data = {
    "X-Real-IP"       = "$proxy_protocol_addr"
    "X-Forwarded-For" = "$proxy_protocol_addr"
  }
}

resource "kubernetes_ingress_v1" "matomo" {
  metadata {
    name      = "matomo-ingress"
    namespace = "analytics"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"    = "true"
      "cert-manager.io/cluster-issuer"                    = var.certificate_issuer_name
      "nginx.ingress.kubernetes.io/backend-protocol"      = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-set-headers"     = kubernetes_config_map.nginx_headers.metadata[0].name
    }
  }

  spec {
    ingress_class_name = var.nginx_ingress_class

    tls {
      hosts = ["analytics.chbrx.com"]
      secret_name = "matomo-cert"
    }

    rule {
      host = "analytics.chbrx.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.matomo.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "test_echo" {
  metadata {
    name      = "echo-test"
    namespace = "default"
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-set-headers" = kubernetes_config_map.nginx_headers.metadata[0].name
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"    = "true"
      "cert-manager.io/cluster-issuer"                    = var.certificate_issuer_name
      "nginx.ingress.kubernetes.io/backend-protocol"      = "HTTP"
    }
  }

  spec {
    ingress_class_name = var.nginx_ingress_class

    rule {
      host = "echo.chbrx.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "echo-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}