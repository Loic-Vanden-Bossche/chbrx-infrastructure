variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "certificate_email" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "ghcr_username" {
  description = "GitHub username used to pull the images"
  type        = string
}

variable "ghcr_token" {
  description = "GitHub secret used to pull the images"
  type        = string
  sensitive   = true
}

variable "runner_image" {
  description = "GitHub runner image"
  type        = string
}

variable "repository_name" {
  description = "GitHub repository name"
  type        = string
}

variable "node_address" {
  description = "Node address for the Kubernetes cluster"
  type        = string
}

variable "plausible_secret_key_base" {
  description = "Secret key base for Plausible Analytics"
  type        = string
  sensitive   = true
}