### Overview

How to build a basic server infrastructure for AWS with Terraform.  This code has a corresponding 
[Discovery Post](https://jarombek.com/blog/sep-3-2018-terraform) on my website `jarombek.com`.

### Files

| Filename               | Description                                                                                |
|------------------------|--------------------------------------------------------------------------------------------|
| `server.tf`            | Terraform IaC for the web server.                                                          |
| `setup.sh`             | Bash script showing how to use the Terraform CLI.                                          |
| `terraform.tfstate`    | Terraform state file which reflects which infrastructure is currently deployed.            |