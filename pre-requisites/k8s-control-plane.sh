#!/bin/bash
set -e

echo "🚀 Initializing Kubernetes Control Plane..."
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

echo "🔐 Setting up kubeconfig..."
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "🌐 Installing Calico Network Plugin..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "✅ Control Plane is ready!"
echo "⚠️ Copy the kubeadm join command from the output above and run it on the Worker Node."
