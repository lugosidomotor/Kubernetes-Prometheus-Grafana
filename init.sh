#!/bin/bash

set -e

#Reason of the double update: https://github.com/hashicorp/terraform/issues/1025
sudo apt-get update -y
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y docker.io
sudo apt-get install socat -y
sudo apt-get install conntrack -y

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
sudo ./get_helm.sh
sudo helm init

curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.18.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

sudo minikube start --vm-driver=none

sudo minikube start –vm-driver=none –extra-config=kubeadm.ignore-preflight-errors=NumCPU –force –cpus 1
