#!/bin/bash
# ============================================================
# Kubernetes Node Initialization Script
# Run on BOTH master and worker nodes
# Usage: sudo bash 01_k8s_init.sh
# ============================================================

set -euo pipefail

echo "============================================"
echo " [1/6] Disabling swap..."
echo "============================================"
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "============================================"
echo " [2/6] Loading kernel modules..."
echo "============================================"
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

echo "============================================"
echo " [3/6] Applying sysctl settings..."
echo "============================================"
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF
sudo sysctl --system

echo "============================================"
echo " [4/6] Installing and configuring containerd..."
echo "============================================"
sudo apt update -y
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "============================================"
echo " [5/6] Installing kubeadm, kubelet, kubectl..."
echo "============================================"
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "============================================"
echo " [6/6] Verifying installation..."
echo "============================================"
kubeadm version
kubectl version --client

echo ""
echo "✅ Kubernetes node initialization complete!"
echo "   → On MASTER: run 'sudo kubeadm init ...' next"
echo "   → On WORKER: run 'sudo kubeadm join ...' next"
echo "[MASTER] Initializing Kubernetes..."
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

echo "[MASTER] Setting up kubectl config..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[MASTER] Installing Calico network plugin..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

echo "[MASTER] Exporting KUBECONFIG..."
export KUBECONFIG=/etc/kubernetes/admin.conf 

echo "[MASTER] Removing control-plane taint..."
kubectl taint nodes --all node-role.kubernetes.io/control-plane- 


