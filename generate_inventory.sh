#!/bin/bash

JENKINS_IP=$(terraform -chdir=terraform output -raw jenkins_public_ip)
K8S_IPS=$(terraform -chdir=terraform output -json | jq -r '.k8s_node_public_ips.value[]')

# Start writing inventory.ini
cat <<EOF > ansible/inventory.ini
[jenkins]
$JENKINS_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[k8s-nodes]
EOF

# Append each K8s node IP
for ip in $K8S_IPS; do
    echo "$ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> ansible/inventory.ini
done
