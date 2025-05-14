resource "helm_release" "pyroscope" {
  name       = "pyroscope"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "pyroscope"
  version    = "1.13.1" # Replace with the latest version if available

  create_namespace = false

  values = [
    yamlencode({
      service = {
        type = "ClusterIP"
      }
      persistence = {
        enabled      = true
        storageClass = "longhorn" # Use your preferred StorageClass
        accessModes  = ["ReadWriteOnce"]
        size         = "10Gi"
      }
    })
  ]
}