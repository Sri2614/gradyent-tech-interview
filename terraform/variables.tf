# Required Variables
variable "cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
}

variable "ingress_host" {
  description = "Hostname for the ingress"
  type        = string
}

# Optional Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "image_repository" {
  description = "Docker image repository"
  type        = string
  default     = "gradyent/tech-interview"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}

variable "ingress_class" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

# ArgoCD Variables
variable "argocd_app_name" {
  description = "ArgoCD Application name"
  type        = string
  default     = "tech-interview-gradyent"
}

variable "argocd_namespace" {
  description = "ArgoCD namespace"
  type        = string
  default     = "argocd"
}

# Git Variables
variable "git_repo_url" {
  description = "Git repository URL"
  type        = string
  default     = "https://github.com/Sri2614/gradyent-tech-interview.git"
}

variable "git_target_revision" {
  description = "Git target revision"
  type        = string
  default     = "HEAD"
}

variable "git_path" {
  description = "Git path in repository"
  type        = string
  default     = "."
}
