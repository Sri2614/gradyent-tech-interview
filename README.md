# Tech Interview EKS Deployment

Deploy `gradyent/tech-interview:latest` on EKS with ArgoCD.

## What This Does

Runs the tech interview app on Kubernetes with:
* Health checks: `GET /` returns "OK", `GET /hello` returns "world"
* Security: non-root containers, network policies
* Resource limits: 100m CPU, 128Mi memory per pod
* ArgoCD: deploy by pushing to git

## Requirements Met

**Scalability**: 2 replicas, pod anti-affinity
**Monitoring**: Readiness/liveness probes on port 8080
**Cost**: Resource limits, no autoscaling overhead
**Ease of Use**: GitOps with ArgoCD

## Bonus Features

* GitHub Actions CI/CD
* SSL with AWS ACM and GoDaddy for DNS
* Network policies for security
* Prometheus monitoring ready


## Configuration

* 2 replicas
* 100m CPU, 128Mi memory per pod
* Health checks on port 8080
* Non-root containers
* Network policies enabled

## Access

* App: https://tech-interview-gradyent.cloudsslcert.com
* ArgoCD: https://tech-interview-argo.cloudsslcert.com

Test:
```bash
curl https://tech-interview-gradyent.cloudsslcert.com/      # returns "OK"
curl https://tech-interview-gradyent.cloudsslcert.com/hello # returns "world"
```
