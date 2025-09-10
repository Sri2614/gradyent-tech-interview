terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

# Data sources for existing EKS cluster
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Providers
provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Application Ingress
resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "${var.argocd_app_name}-ingress"
    namespace = var.namespace
  }
  spec {
    ingress_class_name = var.ingress_class
    rule {
      host = var.ingress_host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.argocd_app_name}-service"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

# ArgoCD Application
resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.argocd_app_name
      namespace = var.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo_url
        targetRevision = var.git_target_revision
        path           = var.git_path
        helm = {
          parameters = [
            {
              name  = "ingress.enabled"
              value = "false"
            },
            {
              name  = "replicaCount"
              value = tostring(var.replicas)
            },
            {
              name  = "image.repository"
              value = var.image_repository
            },
            {
              name  = "image.tag"
              value = var.image_tag
            }
          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=false",
          "Replace=false"
        ]
      }
    }
  }
}

# Outputs
output "cluster_name" {
  value       = data.aws_eks_cluster.cluster.name
  description = "Existing EKS cluster name"
}

output "cluster_endpoint" {
  value       = data.aws_eks_cluster.cluster.endpoint
  description = "API server endpoint for the existing cluster"
}

output "argocd_application_name" {
  value       = kubernetes_manifest.argocd_application.manifest.metadata.name
  description = "ArgoCD Application name"
}
