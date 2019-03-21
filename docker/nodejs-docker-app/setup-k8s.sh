#!/usr/bin/env bash

# Kubernetes Playground Setup for the Node.js Application
# Author: Andrew Jarombek
# Date: 3/20/2019

# Run these commands if you want to use ECR.  I haven't yet found an easy way to get Kubernetes to pull images from ECR
Login="$(aws ecr get-login --region us-east-1 --no-include-email)"
${Login}

git clone https://github.com/AJarombek/devops-prototypes.git
cd devops-prototypes/docker/nodejs-docker-app/

# Push the image onto DockerHub
docker image build -t nodejs-docker-app:latest .
docker image ls

docker login
docker image tag nodejs-docker-app:latest ajarombek/nodejs-docker-app:latest
docker image push ajarombek/nodejs-docker-app:latest

# Initialize a new Kubernetes cluster
sudo kubeadm init

# Commands to run as provided by the kubeadm init command
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Check the status of the nodes in the cluster
kubectl get nodes

# Get all the pods in all namespaces (including the ones used by kubernetes in the 'kube-system' namespace)
kubectl get pods --all-namespaces

# Create a pod network
# Found on: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Remove the taint on the master node which does not allow Pods to be scheduled to it
kubectl taint node ip-10-0-1-133 node-role.kubernetes.io/master:NoSchedule-

# Now we are ready to use YAML config files to provision with Kubernetes
# Create a Pod based on the pod.yml Kubernetes config file
kubectl create -f pod.yml

# Check the status of the Pod
kubectl get pods

# Get JSON formatted Pod info
kubectl get pods -o json nodejs-app

# Get more information about a Pod
kubectl describe pods nodejs-app

# Delete an existing Pod
kubectl delete pods nodejs-app