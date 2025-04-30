resource "helm_release" "loki" {
  name       = "loki"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.29.0"

  create_namespace = false

  values = [
    yamlencode({
      deploymentMode = "SingleBinary"

      singleBinary = {
        replicas = 1
      }

      backend = {
        replicas = 0
      }

      read = {
        replicas = 0
      }

      write = {
        replicas = 0
      }

      loki = {
        auth_enabled = false

        ingester = {
          lifecycler = {
            ring = {
              replication_factor = 1
            }
          }
        }

        storage = {
          type = "filesystem"
          filesystem = {
            directory = "/var/loki"
          }
        }

        schemaConfig = {
          configs = [
            {
              from         = "2025-04-01" # <-- any date before today
              store        = "tsdb"
              object_store = "filesystem"
              schema       = "v13"
              index = {
                prefix = "index_"
                period = "24h"
              }
            }
          ]
        }

        storageConfig = {
          boltdb_shipper = {
            active_index_directory = "/var/loki/index"
            cache_location         = "/var/loki/cache"
          }
          tsdb_shipper = {
            active_index_directory = "/var/loki/tsdb-index"
            cache_location         = "/var/loki/tsdb-cache"
          }
          filesystem = {
            directory = "/var/loki/chunks"
          }
        }

        compactor = {
          working_directory      = "/var/loki/compactor"
          retention_enabled      = true
          delete_request_store   = "filesystem"
        }

        limits_config = {
          retention_period            = "336h"  # 14 days
          allow_structured_metadata   = true
          ingestion_rate_strategy = "global"
        }

        persistence = {
          enabled      = true
          storageClass = "longhorn"
          accessModes  = ["ReadWriteOnce"]
          size         = "50Gi"
          mountPath    = "/var/loki"
        }
      }
    })
  ]
}

resource "helm_release" "promtail" {
  name       = "promtail"
  namespace  = "monitoring"
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
                  action         = "replace"
                  replacement    = "/var/log/pods/*$1/*.log"
                  separator      = "/"
                  source_labels  = ["__meta_kubernetes_pod_uid", "__meta_kubernetes_pod_container_name"]
                  target_label   = "__path__"
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