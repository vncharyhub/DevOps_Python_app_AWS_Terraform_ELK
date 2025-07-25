## 🚀 Kubernetes Setup Overview

### VM Recommendations

| Role          | Instance Type | RAM | Notes                        |
| ------------- | ------------- | --- | ---------------------------- |
| Control Plane | `t2.medium`   | 4GB | Kube master, scheduler, etcd |
| Worker Node   | `t2.small`    | 2GB | Runs your app workloads      |

### 🔐 Open These Ports in AWS Security Group

| Port        | Use               |
| ----------- | ----------------- |
| 22          | SSH               |
| 6443        | Kubernetes API    |
| 10250       | Kubelet API       |
| 30000-32767 | NodePort services |

---

## ⚙️ Setup Instructions

### Step 1: On Both Nodes

Run the common setup script:

```bash
./k8s-common-setup.sh
```

### Step 2: On the Control Plane Only

Run the control plane script:

```bash
./k8s-control-plane.sh
```

### Step 3: Initialize Kubernetes

```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

Copy and save the `kubeadm join` command shown in the output.

### Step 4: Configure `kubectl` on Control Plane

```bash
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Step 5: Install Calico CNI

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
```

---

## 🧹 Join the Worker Node

From the output of Step 3, run the following on the worker node:

```bash
kubeadm join <control-plane-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

---

## ✅ Verify Nodes

On the Control Plane:

```bash
kubectl get nodes
```

Expected Output:

```
NAME           STATUS   ROLES           AGE     VERSION
control-plane  Ready    control-plane   5m      v1.30.x
worker-node    Ready    <none>          2m      v1.30.x
```

---

## 🌐 Test Deployment

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get svc
```

Access using:

```
http://<Worker Node Public IP>:<NodePort>
```

---

## 📌 Summary

| Component         | VM Type      | Notes                         |
| ----------------- | ------------ | ----------------------------- |
| Control Plane     | t2.medium    | Needs RAM for etcd, API       |
| Worker Node       | t2.small     | 2GB is OK for 1–2 pods        |
| OS                | Ubuntu 22.04 | Use the same for both VMs     |
| Container Runtime | containerd   | Default since Kubernetes 1.24 |
