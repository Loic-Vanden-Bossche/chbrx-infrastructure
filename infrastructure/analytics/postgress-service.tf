resource "kubernetes_service" "postgres" {
  metadata {
    name      = "plausible-db"
    namespace = kubernetes_namespace.analytics.metadata[0].name
  }

  spec {
    cluster_ip = "None" # Headless service for StatefulSet DNS
    selector   = {
      app = "plausible-db"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}