
| ------------------------------------------------------------------ |
|                    Kubernetes Setup Overview                       |
| ------------------------------------------------------------------ |
| Role          | Instance Type | RAM | Notes                        |
| ------------- | ------------- | --- | ---------------------------- |
| Control Plane | `t2.medium`   | 4GB | Kube master, scheduler, etcd |
| Worker Node   | `t2.small`    | 2GB | Runs your app workloads      |
| ------------------------------------------------------------------ |

| ---------------------------- |
| Open these ports in your SG  |
| ---------------------------- |
| Port        | Use            |
| ----------- | -------------- |
| 22          | SSH            |
| 6443        | Kubernetes API |
| 10250       | Kubelet API    |
| 30000-32767 | NodePort range |
| ---------------------------- |

## On Both Control Plane & Worker Node run k8s-common-setup.sh script
## On the Control Plane Only k8s-control-plane.sh script

Initialize Control Plane by On the Control Plane node only:

# Initialize the Kubernetes cluster
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
After success, follow the instructions shown (copy them):

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

Install Pod Network (Calico)
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

Join the Worker Node
On the Control Plane, after kubeadm init, you will see a command like this:

kubeadm join <control-plane-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
Copy and paste this command into your Worker Node VM to join the cluster.

Verify Node Join On the Control Plane:

kubectl get nodes
You should see:

NAME           STATUS   ROLES           AGE     VERSION
control-plane  Ready    control-plane   5m      v1.30.x
worker-node    Ready    <none>          2m      v1.30.x

Test Deployment

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get svc
Access via <NodePublicIP>:<nodePort>


Summary
Component	VM Type	Notes
Control Plane	t2.medium	Needs RAM for etcd, API
Worker Node	t2.small	2GB is OK for 1–2 pods
OS	Ubuntu 22.04	Use same for both VMs
Container Runtime	containerd	Default since Kubernetes 1.24+
