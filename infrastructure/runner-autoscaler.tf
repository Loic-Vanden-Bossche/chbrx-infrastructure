resource "kubernetes_manifest" "chbrx_runner_autoscaler" {
  manifest = {
    apiVersion = "actions.summerwind.dev/v1alpha1"
    kind       = "HorizontalRunnerAutoscaler"
    metadata = {
      name      = "chbrx-autoscaler"
      namespace = "actions-runner-system"
    }
    spec = {
      scaleTargetRef = {
        name = kubernetes_manifest.chbrx_runner_deployment.manifest.metadata.name
      }
      minReplicas = 1
      maxReplicas = 5
      metrics = [
        {
          type = "TotalNumberOfQueuedAndInProgressWorkflowRuns"
        }
      ]
    }
  }
}
