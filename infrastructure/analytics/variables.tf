variable "nginx_ingress_class" {
  description = "Ingress class for NGINX Ingress Controller"
  type        = string
}

variable "certificate_issuer_name" {
  description = "Name of the certificate issuer"
  type        = string
}

variable "secret_key_base" {
  description = "Secret key base for Plausible Analytics"
  type        = string
  sensitive   = true
}