#!/bin/bash
# ============================================================
# Kubernetes Bash Completion Setup Script
# Usage: bash 03_k8s_completion.sh
# ============================================================

set -euo pipefail

echo "============================================"
echo " Installing bash-completion..."
echo "============================================"
sudo apt update -y
sudo apt install -y bash-completion

echo "============================================"
echo " Configuring kubectl completion..."
echo "============================================"

# Remove existing completion lines to avoid duplicates
sed -i '/kubectl completion bash/d' ~/.bashrc 2>/dev/null || true
sed -i '/complete -F __start_kubectl/d' ~/.bashrc 2>/dev/null || true

cat <<'EOF' >> ~/.bashrc

# Kubectl bash completion
source <(kubectl completion bash)
complete -F __start_kubectl k
EOF

source ~/.bashrc

echo ""
echo "✅ Bash completion configured successfully!"
echo "   Reload your shell or run: source ~/.bashrc"

source ~/.bashrc
