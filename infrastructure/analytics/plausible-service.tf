resource "kubernetes_service" "plausible" {
  metadata {
    name      = "plausible"
    namespace = kubernetes_namespace.analytics.metadata[0].name
  }
  spec {
    selector = { app = "plausible" }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP"
  }
}