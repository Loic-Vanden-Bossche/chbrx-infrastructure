resource "kubernetes_deployment" "matomo" {
  metadata {
    name      = "matomo"
    namespace = "analytics"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "matomo"
      }
    }

    template {
      metadata {
        labels = {
          app = "matomo"
        }
      }

      spec {
        container {
          name  = "matomo"
          image = "matomo:latest"

          port {
            container_port = 80
          }

          env {
            name  = "MATOMO_DATABASE_HOST"
            value = "matomo-mariadb.analytics.svc.cluster.local"
          }

          env {
            name  = "MATOMO_DATABASE_ADAPTER"
            value = "MYSQLI"
          }

          env {
            name  = "MATOMO_DATABASE_TABLES_PREFIX"
            value = "matomo_"
          }

          env {
            name = "MATOMO_DATABASE_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.matomo_db.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "MATOMO_DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.matomo_db.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name  = "MATOMO_DATABASE_DBNAME"
            value = "matomo"
          }

          volume_mount {
            name       = "matomo-data"
            mount_path = "/var/www/html"
          }
        }

        volume {
          name = "matomo-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.matomo_data.metadata[0].name
          }
        }
      }
    }
  }
}