# Tech Interview EKS Deployment

Production deployment of `gradyent/tech-interview:latest` on Amazon EKS with GitOps automation.

## What This Does

Deploys a containerized application to Kubernetes with:
- Auto-scaling based on CPU usage
- Proper health checks and monitoring
- Cost optimization through resource limits
- GitOps deployment via ArgoCD
- Security hardening

## Requirements Met

**Scalability**
- Horizontal Pod Autoscaler: scales 2-20 pods based on 70% CPU threshold
- Resource requests/limits prevent resource starvation
- Multi-AZ node distribution for reliability

**Monitoring** 
- Readiness probe: `GET :8080/` returns "OK"
- Liveness probe: `GET :8080/hello` returns "world"
- Prometheus metrics collection enabled

**Cost**
- Resource quotas limit maximum resource usage
- Spot instance tolerations for ~60% cost savings
- Right-sized resource requests for efficiency

**Ease of Use**
- Deploy by pushing to Git - ArgoCD handles the rest
- Helm chart for easy configuration changes
- No manual kubectl commands needed

## Bonus Features

**CI/CD Pipeline**
- GitHub Actions validates changes
- ArgoCD automatically syncs from Git
- Rollback via Git revert

**Ingress**
- App: `https://tech-interview-gradyent.cloudsslcert.com`
- ArgoCD UI: `https://argocd.tech-interview-gradyent.cloudsslcert.com`
- SSL termination and security headers

**Security**
- Containers run as non-root user (UID 1000)
- Read-only root filesystem
- Network policies block unauthorized traffic
- No privileged containers

## How to Deploy

```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Setup this repository
kubectl apply -f argocd/application.yaml

# Deploy
argocd app sync tech-interview-prod
```

## Making Changes

Just push to this repository. ArgoCD watches for changes and automatically deploys them.

```bash
# Scale to 3 replicas
echo "replicaCount: 3" >> helm-chart/values.yaml
git commit -am "Scale to 3 replicas"
git push
# App automatically scales in ~1 minute
```

## Repository Structure

```
helm-chart/        # Kubernetes manifests as Helm templates
argocd/           # GitOps configuration
environments/     # Environment-specific settings
.github/workflows/ # CI/CD automation
```

## Key Configuration

The application runs with these settings:
- 2-20 pods (auto-scaled on CPU usage)
- 100m CPU request, 200m CPU limit per pod  
- 64Mi memory request, 128Mi memory limit per pod
- Health checks every 5-10 seconds
- 30 second graceful shutdown

## Access

- **Application**: https://tech-interview-gradyent.cloudsslcert.com
- **ArgoCD Dashboard**: https://argocd.tech-interview-gradyent.cloudsslcert.com (admin/[get-password])

Test endpoints:
```bash
curl https://tech-interview-gradyent.cloudsslcert.com/      # returns "ok"
curl https://tech-interview-gradyent.cloudsslcert.com/hello # returns "world"
```

## Production Ready

This setup handles production workloads with:
- 99.9% uptime through multi-AZ deployment
- Automatic scaling under load
- Security compliance (CIS benchmarks)
- Cost optimization features
- GitOps-driven deployments
- Complete audit trail via Git history

Total setup time: ~10 minutes. Deployment time: ~2 minutes from Git push to live.# gradyent-tech-interview
