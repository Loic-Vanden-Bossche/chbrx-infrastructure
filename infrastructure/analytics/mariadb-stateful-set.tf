resource "kubernetes_stateful_set" "mariadb" {
  metadata {
    name      = "matomo-mariadb"
    namespace = "analytics"
  }

  spec {
    service_name = "matomo-mariadb-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "matomo-mariadb"
      }
    }

    template {
      metadata {
        labels = {
          app = "matomo-mariadb"
        }
      }

      spec {
        container {
          name  = "mariadb"
          image = "mariadb:10.5"

          port {
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.matomo_db.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "matomo"
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.matomo_db.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.matomo_db.metadata[0].name
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "mariadb-data"
            mount_path = "/var/lib/mysql"
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/mysql/conf.d"
            read_only  = true
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.mariadb_config.metadata[0].name
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "mariadb-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }
  }
}