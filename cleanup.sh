#!/bin/bash
# ============================================================
# Kubernetes Full Cleanup / Uninstall Script
# Removes kubeadm, kubelet, kubectl, containerd and all config
# Run on EACH node (master and workers)
# Usage: sudo bash 04_k8s_cleanup.sh
# ============================================================

set -euo pipefail

echo "============================================"
echo " [1/8] Resetting kubeadm..."
echo "============================================"
sudo kubeadm reset -f || true

echo "============================================"
echo " [2/8] Stopping and disabling services..."
echo "============================================"
sudo systemctl stop kubelet       || true
sudo systemctl stop containerd    || true
sudo systemctl disable kubelet    || true
sudo systemctl disable containerd || true

echo "============================================"
echo " [3/8] Removing kubeadm, kubelet, kubectl..."
echo "============================================"
sudo apt-mark unhold kubelet kubeadm kubectl 2>/dev/null || true
sudo apt-get remove -y --purge kubelet kubeadm kubectl   || true
sudo apt-get autoremove -y                               || true

echo "============================================"
echo " [4/8] Removing containerd..."
echo "============================================"
sudo apt-get remove -y --purge containerd || true
sudo apt-get autoremove -y                || true

echo "============================================"
echo " [5/8] Deleting config and data directories..."
echo "============================================"
sudo rm -rf /etc/kubernetes
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/containerd
sudo rm -rf /opt/cni
sudo rm -rf /etc/cni
sudo rm -rf /var/lib/cni
sudo rm -rf ~/.kube

echo "============================================"
echo " [6/8] Removing APT repo and keyring..."
echo "============================================"
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt-get update -y

echo "============================================"
echo " [7/8] Cleaning up network interfaces..."
echo "============================================"
sudo ip link delete cni0    2>/dev/null || true
sudo ip link delete flannel.1 2>/dev/null || true
sudo ip link delete weave   2>/dev/null || true
sudo ip link delete tunl0   2>/dev/null || true
sudo ip link delete calico   2>/dev/null || true
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X

echo "============================================"
echo " [8/8] Cleaning up kernel modules and sysctl..."
echo "============================================"
sudo rm -f /etc/modules-load.d/k8s.conf
sudo rm -f /etc/sysctl.d/k8s.conf
sudo sysctl --system

echo "============================================"
echo " Cleaning up aliases and completions from ~/.bashrc..."
echo "============================================"
sed -i '/# Kubernetes aliases/,/^$/d'        ~/.bashrc 2>/dev/null || true
sed -i '/kubectl completion bash/d'           ~/.bashrc 2>/dev/null || true
sed -i '/complete -F __start_kubectl/d'       ~/.bashrc 2>/dev/null || true
sed -i '/# Kubectl bash completion/d'         ~/.bashrc 2>/dev/null || true

echo ""
echo "✅ Kubernetes fully removed!"
echo "   It is recommended to REBOOT the node to ensure a clean state."
echo "   Run: sudo reboot"