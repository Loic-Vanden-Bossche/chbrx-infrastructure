resource "kubernetes_service" "matomo" {
  metadata {
    name      = "matomo"
    namespace = "analytics"
  }

  spec {
    selector = {
      app = "matomo"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}