resource "kubernetes_persistent_volume_claim" "matomo_data" {
  metadata {
    name      = "matomo-data"
    namespace = "analytics"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

