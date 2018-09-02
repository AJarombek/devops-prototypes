#!/usr/bin/env bash

# Author: Andrew Jarombek
# Date: 8/29/2018
# Terraform Setup for AWS Lambda function

terraform init
terraform plan

# If you forget this step, terraform apply will error out
export AWS_ACCESS_KEY_ID=XXX
export AWS_SECRET_ACCESS_KEY=XXX

terraform apply