resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart      = "sonarqube"
  version = "2025.2.0" # Replace with the latest community-supported version

  create_namespace = false

  values = [
    yamlencode(
      {
        community = {
          enabled = true
        }

        monitoringPasscode = "mySecurePass"

        ingress = {
          enabled = true
          hosts = [
            {
              name = "sonarqube.chbrx.com"
              path = "/"
            }
          ]
          annotations = {
            "nginx.ingress.kubernetes.io/proxy-body-size"    = "64m"
            "nginx.ingress.kubernetes.io/proxy-read-timeout" = "600"
            "nginx.ingress.kubernetes.io/proxy-send-timeout" = "600"
            "cert-manager.io/cluster-issuer"                 = "letsencrypt-production"
            "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
            "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
          }
          tls = [
            {
              hosts = ["sonarqube.chbrx.com"]
              secretName = "sonarqube-tls"
            }
          ]
        }

        sonarProperties = {
          "sonar.web.contextPath" = ""
          "sonar.web.port"        = "9000"
          "sonar.web.forwarded"   = "true"
        }

        persistence = {
          enabled      = true
          storageClass = "longhorn"
          size         = "10Gi"
        }
      }
    )
  ]
}