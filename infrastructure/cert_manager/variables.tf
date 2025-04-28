variable "email" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
}

variable "nginx_ingress_class" {
  description = "Ingress class for NGINX Ingress Controller"
  type        = string
}