#!/bin/bash
set -euo pipefail

# ============================================
# Cluster Bootstrap Script
# ============================================
# Run this after EKS cluster is created
# Usage: ./setup-cluster.sh

echo "🚀 Starting cluster setup..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ============================================
# 1. Create Namespaces
# ============================================
echo -e "${GREEN}[1/6] Creating namespaces...${NC}"
kubectl create namespace coolad-app --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# ============================================
# 2. Install NGINX Ingress Controller
# ============================================
echo -e "${GREEN}[2/6] Installing NGINX Ingress Controller...${NC}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/aws/deploy.yaml

echo "Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s || echo -e "${YELLOW}Warning: Ingress controller not ready yet${NC}"

# ============================================
# 3. Install ArgoCD
# ============================================
echo -e "${GREEN}[3/6] Installing ArgoCD...${NC}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD to be ready..."
kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=argocd-server \
  --timeout=300s || echo -e "${YELLOW}Warning: ArgoCD not ready yet${NC}"

# Get ArgoCD initial admin password
echo -e "${YELLOW}ArgoCD Admin Password:${NC}"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Patch ArgoCD to use LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# ============================================
# 4. Deploy Monitoring Stack
# ============================================
echo -e "${GREEN}[4/6] Deploying monitoring stack...${NC}"
kubectl apply -f monitoring/namespace.yaml
kubectl apply -f monitoring/prometheus/clusterrole.yaml
kubectl apply -f monitoring/prometheus/config.yaml
kubectl apply -f monitoring/prometheus/deployment.yaml
kubectl apply -f monitoring/grafana/deployment.yaml
kubectl apply -f monitoring/node-exporter/daemonset.yaml
kubectl apply -f monitoring/kube-state-metrics/deployment.yaml

# ============================================
# 5. Deploy ArgoCD Application
# ============================================
echo -e "${GREEN}[5/6] Deploying ArgoCD Application...${NC}"
kubectl apply -f argocd/application.yaml

# ============================================
# 6. Verify
# ============================================
echo -e "${GREEN}[6/6] Verifying deployments...${NC}"
echo ""
echo "=== Namespaces ==="
kubectl get namespaces

echo ""
echo "=== Pods (all namespaces) ==="
kubectl get pods -A

echo ""
echo "=== Services ==="
kubectl get svc -A

echo ""
echo -e "${GREEN}✅ Cluster setup complete!${NC}"
echo ""
echo "📋 Access Points:"
echo "  - ArgoCD:     kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "  - Prometheus: kubectl port-forward svc/prometheus -n monitoring 9090:9090"
echo "  - Grafana:    kubectl port-forward svc/grafana -n monitoring 3000:3000"
echo "  - App:        kubectl get svc -n coolad-app"
