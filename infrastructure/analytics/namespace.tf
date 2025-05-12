resource "kubernetes_namespace" "analytics" {
  metadata {
    name = "analytics"
  }
}
