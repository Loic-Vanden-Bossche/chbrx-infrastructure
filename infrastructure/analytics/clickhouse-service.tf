resource "kubernetes_service" "clickhouse" {
  metadata {
    name      = "plausible-events-db"
    namespace = kubernetes_namespace.analytics.metadata[0].name
  }

  spec {
    cluster_ip = "None" # Required for StatefulSet DNS discovery
    selector   = { app = "plausible-events-db" }

    port {
      port        = 8123
      target_port = 8123
    }
  }
}