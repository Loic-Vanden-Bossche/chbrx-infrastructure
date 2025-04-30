resource "helm_release" "kube_prometheus_stack" {
  name      = "kube-prometheus-stack"
  namespace = kubernetes_namespace.monitoring.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version = "71.0.0" # (or latest stable)

  create_namespace = false

  values = [
    yamlencode({
      grafana = {
        enabled       = true
        adminPassword = "supersecret"

        additionalDataSources = [
          {
            name   = "Loki"
            type   = "loki"
            url    = "http://loki.monitoring.svc.cluster.local:3100"
            access = "proxy"
            jsonData = {}
          },
          {
            name   = "Pyroscope"
            type   = "grafana-pyroscope-datasource"
            url    = "http://pyroscope.monitoring.svc.cluster.local:4040"
            access = "proxy"
            jsonData = {}
          }
        ]

        ingress = {
          enabled          = true
          ingressClassName = var.nginx_ingress_class
          annotations = {
            "cert-manager.io/cluster-issuer" = var.certificate_issuer_name
          }
          hosts = ["grafana.chbrx.com"]
          tls = [
            {
              hosts = ["grafana.chbrx.com"]
              secretName = "grafana-tls"
            }
          ]
        }
      }

      prometheus = {
        prometheusSpec = {
          retention                               = "10d"
          serviceMonitorSelectorNilUsesHelmValues = false
        }
      }
    })
  ]
}