resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"

  create_namespace = false

  values = [
    yamlencode({
      args = [
        "--kubelet-insecure-tls", # Important if you don't have kubelet serving certificates
        "--kubelet-preferred-address-types=InternalIP,Hostname,ExternalIP"
      ]
    })
  ]
}