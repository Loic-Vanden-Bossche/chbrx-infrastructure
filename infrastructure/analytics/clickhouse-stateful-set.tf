resource "kubernetes_stateful_set" "clickhouse" {
  metadata {
    name      = "plausible-events-db"
    namespace = kubernetes_namespace.analytics.metadata[0].name
  }

  spec {
    service_name = kubernetes_service.clickhouse.metadata[0].name
    replicas     = 1

    selector {
      match_labels = {
        app = "plausible-events-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "plausible-events-db"
        }
      }

      spec {
        container {
          name  = "clickhouse"
          image = "clickhouse/clickhouse-server:24.12-alpine"

          env {
            name  = "CLICKHOUSE_SKIP_USER_SETUP"
            value = "1"
          }

          port {
            container_port = 8123
          }

          volume_mount {
            name       = "event-data"
            mount_path = "/var/lib/clickhouse"
          }

          volume_mount {
            name       = "event-logs"
            mount_path = "/var/log/clickhouse-server"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "event-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "event-logs"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "512Mi"
          }
        }
      }
    }
  }
}