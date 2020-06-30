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

#KUBECTL INSTALL
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

openssl genrsa -out dev.key 2048
openssl req -new -key prometheus.key -out dev.csr -subj "/CN=dev/O=group"
openssl x509 -req -in prometheus.csr -CA /home/cloud_user/.minikube/ca.crt -CAkey /home/cloud_user/.minikube/ca.key -CAcreateserial -out prometheus.crt -days 500

sudo kubectl config set-credentials prometheus --client-certificate=/home/cloud_user/keys/prometheus.crt  --client-key=/home/cloud_user/keys/prometheus.key
sudo kubectl config set-context prometheus --cluster=minikube --namespace=default --user=prometheus

#HELM INSTALL
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
sudo ./get_helm.sh
sudo helm init

sudo minikube addons enable ingress
#Note: Minikube can only expose Services through NodePort. The EXTERNAL-IP is always pending.
sudo kubectl patch svc ill-bat-prometheus-server  -p '{"spec": {"type": "NodePort"}}'
#sudo minikube service wordpress --url

sudo minikube start --vm-driver=none
sudo helm install stable/prometheus

#TEMP:
#kubectl get pod,svc -n kube-system
#sudo minikube start –vm-driver=none –extra-config=kubeadm.ignore-preflight-errors=NumCPU –force –cpus 1

#How to access Kubernetes API when using minkube?
#https://stackoverflow.com/questions/40720979/how-to-access-kubernetes-api-when-using-minkube
#https://itnext.io/kubernetes-monitoring-with-prometheus-exporters-a-service-discovery-and-its-roles-ce63752e5a1
