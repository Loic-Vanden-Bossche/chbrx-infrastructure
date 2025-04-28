resource "helm_release" "arc" {
  name             = "actions-runner-controller"
  namespace        = kubernetes_namespace.actions_runner_system.metadata[0].name
  create_namespace = false

  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  version    = "0.23.7"

  values = [
    yamlencode({
      certManager = {
        enabled = true
      },
      authSecret = {
        create       = true
        github_token = var.github_pat
      }
    })
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }
}
