resource "kubernetes_manifest" "chbrx_runner_deployment" {
  manifest = {
    apiVersion = "actions.summerwind.dev/v1alpha1"
    kind       = "RunnerDeployment"
    metadata = {
      name      = "chbrx-runner"
      namespace = kubernetes_namespace.actions_runner_system.metadata[0].name
    }
    spec = {
      replicas = 1
      template = {
        spec = {
          repository = var.repository_name
          image      = lower(var.image)
          imagePullSecrets = [
            {
              name = var.image_pull_secret
            }
          ]
        }
      }
    }
  }
}