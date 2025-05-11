module "action_runners" {
  depends_on = [module.cert_manager]
  source     = "./action-runners"

  image             = var.runner_image
  repository_name   = var.repository_name
  github_pat        = var.github_pat
  image_pull_secret = kubernetes_secret.image_pull.metadata[0].name
}

module "cert_manager" {
  depends_on = [module.network]
  source     = "./cert_manager"

  nginx_ingress_class = module.nginx.ingress_class
  email               = var.certificate_email
}

module "monitoring" {
  depends_on = [module.storage]
  source     = "./monitoring"

  nginx_ingress_class     = module.nginx.ingress_class
  certificate_issuer_name = module.cert_manager.issuer_name
}

module "storage" {
  depends_on = [module.network]
  source     = "./storage"
}

module "nginx" {
  depends_on = [module.network]
  source     = "./nginx"
}

module "network" {
  source = "./network"

  node_address = var.node_address
}

