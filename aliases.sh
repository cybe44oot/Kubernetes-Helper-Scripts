#!/bin/bash
# ============================================================
# Kubernetes Aliases Setup Script
# Usage: bash 02_k8s_aliases.sh
# ============================================================

#note: after this write bash aliases.sh or whatever you named this file and then source ~/.bashrc to apply the changes

set -euo pipefail

echo "============================================"
echo " Adding Kubernetes aliases to ~/.bashrc..."
echo "============================================"

# Remove any existing k8s alias block to avoid duplicates
sed -i '/# Kubernetes aliases/,/^EOF/d' ~/.bashrc 2>/dev/null || true

cat <<'EOF' >> ~/.bashrc

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgn='kubectl get nodes'
alias kgd='kubectl get deployments'
alias kgs='kubectl get svc'
alias kgns='kubectl get namespaces'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kdp='kubectl describe pod'
alias kdn='kubectl describe node'
alias klog='kubectl logs'
alias kex='kubectl exec -it'
EOF

source ~/.bashrc

echo ""
echo "✅ Aliases added and sourced successfully!"
echo "   Reload your shell or run: source ~/.bashrc"

source ~/.bashrc


