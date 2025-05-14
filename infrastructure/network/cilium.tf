resource "helm_release" "cilium" {
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.17.3"

  create_namespace = true

  values = [
    yamlencode({
      kubeProxyReplacement      = true
      ipam = {
        mode = "kubernetes"
      }
      operator = {
        replicas = 1
      }
      k8sServiceHost = var.node_address
      k8sServicePort = 6443

      ipv4NativeRoutingCIDR = "10.1.0.0/24"

      routingMode = "native"

      loadBalancer = {
        enabled = true
        mode    = "dsr"
      }

      hostServices = {
        enabled = true
      }

      masquerade = false

      nodePort = {
        enabled = true
      }

      healthChecking = true

      mtu = 1450
    })
  ]
}