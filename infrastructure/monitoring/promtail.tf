resource "helm_release" "promtail" {
  name       = "promtail"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.16.6"

  create_namespace = false

  values = [
    yamlencode({
      config = {
        clients = [
          {
            url = "http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push"
          }
        ]

        snippets = {
          scrape_configs = [
            {
              job_name = "kubernetes-pods"

              kubernetes_sd_configs = [
                {
                  role = "pod"
                }
              ]

              relabel_configs = [
                {
                  source_labels = ["__meta_kubernetes_pod_node_name"]
                  target_label  = "__host__"
                },
                {
                  source_labels = ["__meta_kubernetes_namespace"]
                  target_label  = "namespace"
                },
                {
                  source_labels = ["__meta_kubernetes_pod_name"]
                  target_label  = "pod"
                },
                {
                  source_labels = ["__meta_kubernetes_pod_container_name"]
                  target_label  = "container"
                },
                {
                  action        = "replace"
                  replacement   = "/var/log/pods/*$1/*.log"
                  separator     = "/"
                  source_labels = ["__meta_kubernetes_pod_uid", "__meta_kubernetes_pod_container_name"]
                  target_label  = "__path__"
                }
              ]
            }
          ]
        }
      }

      podSecurityContext = {
        fsGroup = 0
      }

      securityContext = {
        runAsUser  = 0
        runAsGroup = 0
        privileged = true
      }

      daemonset = {
        hostPID = true
      }
    })
  ]
}