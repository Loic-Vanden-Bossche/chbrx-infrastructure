resource "kubernetes_service" "mariadb_headless" {
  metadata {
    name      = "matomo-mariadb"
    namespace = "analytics"
  }

  spec {
    cluster_ip = "None"
    selector = {
      app = "matomo-mariadb"
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}