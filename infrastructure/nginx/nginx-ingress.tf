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

        # ✅ enable snippet annotations at the controller level
        allowSnippetAnnotations = true

        service = {
          enabled               = true
          type                  = "NodePort"
          externalTrafficPolicy = "Local"
          ports                 = { http = 80, https = 443 }
          nodePorts             = { http = 30080, https = 30443 }
        }

        ingressClassResource = {
          name    = var.ingress_class
          enabled = true
          default = true
        }

        metrics = { enabled = true }

        admissionWebhooks = {
          enabled = true
          patch   = { enabled = true }
        }

        # ✅ also allow Critical-risk annotations (required for snippets)
        config = {
          annotations-risk-level = "Critical"
          # (your existing settings, kept as-is)
          use-proxy-protocol         = "false"
          real-ip-header             = "proxy_protocol"
          set-real-ip-from           = "0.0.0.0/0"
          use-forwarded-headers      = "true"
          compute-full-forwarded-for = "true"
          enable-gzip                = "true"
          gzip-types                 = "text/plain text/css text/javascript application/json application/javascript application/xml+rss application/atom+xml image/svg+xml"
          gzip-min-length            = "256"
          gzip-vary                  = "true"
          enable-brotli              = "true"
          brotli-level               = "6"
          brotli-types               = "text/plain text/css text/javascript application/json application/javascript application/xml+rss application/atom+xml image/svg+xml"
          proxy-buffering            = "on"
        }

        extraArgs = { enable-ssl-passthrough = "" }

        resources = {
          requests = { cpu = "100m", memory = "128Mi" }
          limits   = { cpu = "500m", memory = "512Mi" }
        }

        nodeSelector = {}
        affinity     = {}
      }
    })
  ]
}