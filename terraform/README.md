# Tech Interview Terraform Module

Terraform module to create ArgoCD Application for the Gradyent tech interview app on existing EKS cluster.

## What This Does

- Connects to your existing EKS cluster
- Creates the application ingress resource
- Creates ArgoCD Application resource
- ArgoCD handles the actual Helm deployment via GitOps

## Prerequisites

- Existing EKS cluster
- ArgoCD installed in the cluster
- AWS CLI configured
- kubectl configured
- Terraform >= 1.0

## Quick Start

1. **Copy and edit variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit cluster_name and ingress_host if needed
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Required Variables

- `cluster_name`: Your EKS cluster name
- `ingress_host`: Your domain name

## How It Works

1. Terraform connects to your existing EKS cluster
2. Creates the application ingress resource
3. Creates ArgoCD Application resource (with ingress disabled in Helm)
4. ArgoCD syncs and deploys the Helm chart from Git
5. Application becomes available at your ingress host

## Example

```hcl
cluster_name = "my-eks-cluster"
ingress_host = "app.example.com"
```

## Cleanup

```bash
terraform destroy
```
