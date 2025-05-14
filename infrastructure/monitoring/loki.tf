resource "helm_release" "loki" {
  name       = "loki"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
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
          working_directory    = "/var/loki/compactor"
          retention_enabled    = true
          delete_request_store = "filesystem"
        }

        limits_config = {
          retention_period          = "336h" # 14 days
          allow_structured_metadata = true
          ingestion_rate_strategy   = "global"
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
