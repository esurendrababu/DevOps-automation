#!/bin/bash

# AWS CLI Configuration
aws configure

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# Install kops
wget https://github.com/kubernetes/kops/releases/download/v1.25.0/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

# Create and configure S3 bucket
aws s3api create-bucket --bucket bucketname.k8s.local --region us-east-1
aws s3api put-bucket-versioning --bucket bucketname.k8s.local --versioning-configuration Status=Enabled

# Export KOPS_STATE_STORE
export KOPS_STATE_STORE=s3://cbucketname.k8s.local

# Create Kubernetes cluster
kops create cluster \
  --name surendra.k8s.local \
  --zones us-east-1a \
  --cloud aws \
  --master-count=1 \
  --master-size t2.medium \
  --node-count=2 \
  --node-size t2.medium

# Apply cluster configuration
kops update cluster --name surendra.k8s.local --yes --admin
