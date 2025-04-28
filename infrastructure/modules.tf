module "action_runners" {
  depends_on = [module.cert_manager]

  source = "./action-runners"

  image             = var.runner_image
  repository_name   = var.repository_name
  github_pat        = var.github_pat
  image_pull_secret = kubernetes_secret.image_pull.metadata[0].name
}

module "cert_manager" {
  source = "./cert_manager"

  nginx_ingress_class = module.nginx.ingress_class
  email               = var.certificate_email
}

module "nginx" {
  source = "./nginx"
}

