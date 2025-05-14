

resource "helm_release" "longhorn" {
  name      = "longhorn"
  namespace = kubernetes_namespace.storage.metadata[0].name

  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.8.1"

  create_namespace = false

  values = [
    yamlencode({
      defaultSettings = {
        defaultReplicaCount = 1
        defaultDataPath     = "/var/lib/longhorn"
      }
      persistence = {
        defaultClass = true
      }
      ingress = {
        enabled = false
      }
    })
  ]
}