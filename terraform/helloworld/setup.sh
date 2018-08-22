#!/usr/bin/env bash

# Author: Andrew Jarombek
# Date: 7/31/2018
# Setup terraform for IAC (Infrastructure as Code)

# Add terraform to the PATH variable (MacOS)
sudo vi /etc/paths

# Check if terraform is properly installed and added to the path
terraform

export AWS_ACCESS_KEY_ID=XXX
export AWS_SECRET_ACCESS_KEY=XXX

# Initialize a working directory for terraform
terraform init

# Plan out what changes terraform will make when executed
terraform plan

# Execute the terraform files
terraform apply