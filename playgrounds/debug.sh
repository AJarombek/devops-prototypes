#!/usr/bin/env bash

# Debugging the playgrounds and CloudFormation stacks
# Author: Andrew Jarombek
# Date: 3/12/2019

# Debug UserData
sudo nano /var/log/cloud-init-output.log

# Debug CloudFormation::Init
sudo nano /var/log/cfn-init.log