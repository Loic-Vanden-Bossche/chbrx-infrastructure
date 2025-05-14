resource "kubernetes_secret" "matomo_db" {
  metadata {
    name      = "matomo-db-secret"
    namespace = "analytics"
  }

  data = {
    username = base64encode("matomo_user")
    password = base64encode("matomo_password")
  }

  type = "Opaque"
}