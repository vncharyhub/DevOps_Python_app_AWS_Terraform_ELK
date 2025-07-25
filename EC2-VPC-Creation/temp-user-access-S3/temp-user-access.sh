#!/bin/bash

mkdir tf-run
cp temp-user-access-S3.tf /tf-run
cd /tf-run

terraform init
terraform apply -auto-approve

echo "Sleeping 10 minutes before auto destroy..."
sleep 600
terraform destroy -auto-approve
