# Gradyent Tech Interview - EKS Setup

This repo contains the Kubernetes deployment for the Gradyent tech interview application.

## What's Included

I've set up a production-ready deployment that runs the `gradyent/tech-interview:latest` image on EKS. The app has two endpoints:
- `GET /` returns "OK" 
- `GET /hello` returns "world"

## Interview Requirements

Here's how I addressed each requirement:

**Scalability**: Running 2 replicas with pod anti-affinity to spread across nodes

**Monitoring**: Added readiness and liveness probes on port 8080

**Cost**: Set resource limits and kept it simple (no autoscaling overhead)

**Ease of Use**: Everything deploys via ArgoCD

## Extra Features

I also added some nice-to-haves:
* GitHub Actions for CI/CD
* SSL certificates with AWS ACM and GoDaddy DNS
* Network policies for security
* Prometheus monitoring labels (ready to go)

## Setup Details

The deployment runs:
* 2 pod replicas
* 100m CPU, 128Mi memory per pod
* Health checks on port 8080
* Non-root containers for security
* Network policies enabled

## How to Access

**Application**: https://tech-interview-gradyent.cloudsslcert.com

Test the endpoints:
```bash
curl https://tech-interview-gradyent.cloudsslcert.com/      # should return "OK"
curl https://tech-interview-gradyent.cloudsslcert.com/hello # should return "world"
```

**ArgoCD UI**: 
```bash
# Port forward to ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get the admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Open browser to: https://localhost:8080
# Login with: admin / [password from above]
```
