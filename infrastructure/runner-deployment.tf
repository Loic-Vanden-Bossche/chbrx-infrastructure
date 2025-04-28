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
          image      = var.runner_image
          imagePullSecrets = [
            {
              name = kubernetes_secret.image_pull.metadata[0].name
            }
          ]
        }
      }
    }
  }
}