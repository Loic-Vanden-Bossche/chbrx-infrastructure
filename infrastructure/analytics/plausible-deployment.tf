resource "kubernetes_deployment" "plausible" {
  metadata {
    name      = "plausible"
    namespace = kubernetes_namespace.analytics.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "plausible"
      }
    }

    template {
      metadata {
        labels = {
          app = "plausible"
        }
      }

      spec {
        container {
          name  = "plausible"
          image = "ghcr.io/plausible/community-edition:v3.0.1"

          command = ["sh", "-c"]
          args    = ["/entrypoint.sh db createdb && /entrypoint.sh db migrate && /entrypoint.sh run"]

          env_from {
            secret_ref {
              name = kubernetes_secret.plausible_env.metadata[0].name
            }
          }

          port {
            container_port = 8000
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 8000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 8000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          volume_mount {
            name       = "plausible-data"
            mount_path = "/var/lib/plausible"
          }
        }

        volume {
          name = "plausible-data"
          empty_dir {}
        }
      }
    }
  }
}
