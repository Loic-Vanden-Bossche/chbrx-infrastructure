resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = kubernetes_namespace.nginx_ingress.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({
      controller = {
        replicaCount = 1

        service = {
          enabled = true
          type    = "NodePort"
          externalTrafficPolicy = "Local"
          ports = {
            http  = 80
            https = 443
          }

          nodePorts = {
            http  = 30080
            https = 30443
          }
        }

        ingressClassResource = {
          name    = var.ingress_class
          enabled = true
          default = true
        }

        metrics = {
          enabled = true
        }

        admissionWebhooks = {
          enabled = true
          patch = {
            enabled = true
          }
        }

        config = {
          use-proxy-protocol         = "true"
          real-ip-header             = "proxy_protocol"
          set-real-ip-from           = "0.0.0.0/0"
          use-forwarded-headers      = "true"
          compute-full-forwarded-for = "true"
        }

        extraArgs = {
          enable-ssl-passthrough = ""
        }

        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }

        nodeSelector = {}
        affinity     = {}
      }
    })
  ]
}
