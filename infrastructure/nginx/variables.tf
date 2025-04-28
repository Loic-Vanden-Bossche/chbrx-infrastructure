variable "ingress_class" {
  description = "Ingress class to use for the NGINX Ingress Controller"
  type        = string
  default     = "nginx"
}