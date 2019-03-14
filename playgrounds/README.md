### Overview

Playground linux EC2 instances for working with Docker and Kubernetes.  This helps me avoid installing containers on my 
local machine for testing.

### Files

| Filename            | Description                                                                             |
|---------------------|-----------------------------------------------------------------------------------------|
| `docker/`           | Terraform and CloudFormation code for the docker playground infrastructure.             |
| `kubernetes/`       | Terraform and CloudFormation code for the kubernetes playground infrastructure.         |
| `debug.sh`          | Bash script with code to debug the CloudFormation infrastructure.                       |
| `key-gen.sh`        | Bash script which generates a SSH Key for EC2 instance connection.                      |