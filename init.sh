#!/bin/bash

set -e

#Reason of the double update: https://github.com/hashicorp/terraform/issues/1025
sudo apt-get update -y
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y docker.io
sudo apt-get install socat -y
sudo apt-get install conntrack -y

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

sudo apt-get install kubectl -y

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
sudo ./get_helm.sh
sudo helm init


sudo minikube start --vm-driver=none
sudo helm install stable/prometheus

#sudo minikube start –vm-driver=none –extra-config=kubeadm.ignore-preflight-errors=NumCPU –force –cpus 1
