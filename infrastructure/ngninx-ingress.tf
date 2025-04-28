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

        hostPort = {
          enabled = true
          ports = {
            http  = 80
            https = 443
          }
        }

        service = {
          enabled = false
        }

        ingressClassResource = {
          name    = "nginx"
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