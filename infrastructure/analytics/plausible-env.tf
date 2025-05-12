resource "kubernetes_secret" "plausible_env" {
  metadata {
    name      = "plausible-env"
    namespace = kubernetes_namespace.analytics.metadata[0].name
  }

 data = {
    BASE_URL                = "https://plausible.chbrx.com"
    SECRET_KEY_BASE         = var.secret_key_base
    DATABASE_URL            = "postgres://postgres:postgres@plausible-db:5432/postgres"
    CLICKHOUSE_DATABASE_URL = "http://plausible-events-db:8123/plausible"
  }

  type = "Opaque"
}