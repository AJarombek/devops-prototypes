### Overview

Kubernetes configuration files which are passed to the Kubernetes API.  This can be accomplished with the following 
command on the Kubernetes cluster.

```
kubectl create -f <yml-filename>
```

### Files

| Filename             | Description                                                                             |
|----------------------|-----------------------------------------------------------------------------------------|
| `all-in-one.yml`     | Kubernetes configuration for a Pod and Service.                                         |
| `clusterip-svc.yml`  | Kubernetes configuration for an experimental ClusterIP Service.                         |
| `ingress.yml`        | Kubernetes configuration for an experimental Ingress configuration.                     |
| `nodeport-svc.yml`   | Kubernetes configuration for an inline documented NodePort Service.                     |
| `pod.yml`            | Kubernetes configuration for an inline documented Pod.                                  |
| `setup-k8s.sh`       | Bash commands to set up the app with Kubernetes.                                        |