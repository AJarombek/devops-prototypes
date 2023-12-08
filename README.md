# devops-prototypes

![Maintained Label](https://img.shields.io/badge/Maintained-No-red?style=for-the-badge)
![Deprecated Label](https://img.shields.io/badge/Deprecated-Yes-lightgray?style=for-the-badge)
![Archived Label](https://img.shields.io/badge/Archived-Yes-lightgray?style=for-the-badge)

> Code Migrated to [andy-jarombek-research](https://github.com/AJarombek/andy-jarombek-research)

### Overview

Contains prototypes for my initial DevOps explorations in certain technologies.  Currently im using AWS to build cloud 
infrastructure (although I may use other cloud providers in the future).  I'm also working with provider agnostic 
technologies such as Jenkins, Docker, Kubernetes, and more!

This repository also contains playgrounds for Kubernetes and Docker in my AWS account.  They exist in my Sandbox VPC, 
which is defined in my private [global-aws-infrastructure](https://github.com/AJarombek/global-aws-infrastructure) 
repository.

### Directories

| Directory Name    | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `airflow`         | Docker compose setup for a basic Airflow environment.                       |
| `docker`          | Basic CLI commands and applications for Docker.                             |
| `jenkins`         | Initial Jenkins exploration with the Job DSL Plugin.                        |
| `playgrounds`     | Playground environments for Kubernetes and Docker on AWS.                   |
| `samples`         | Small Infrastructure/Code samples which are deployed, tested, and removed.  |
| `splunk`          | Splunk environment and basic queries.                                       |
| `terraform`       | Initial Terraform explorations with Lambda, EC2, and S3 on AWS.             |
