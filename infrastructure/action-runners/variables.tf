variable "repository_name" {
  description = "GitHub repository name"
  type        = string
}

variable "image" {
  description = "Docker image for the action runner"
  type        = string
}

variable "image_pull_secret" {
  description = "Name of the image pull secret"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}