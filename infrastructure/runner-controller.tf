resource "helm_release" "arc" {
  name             = "actions-runner-controller"
  namespace        = "actions-runner-system"
  create_namespace = true

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
