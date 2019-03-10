#!/usr/bin/env bash

# Generate a key to connect to the docker sandbox ec2 instance.
# This script must execute BEFORE the instance is created.
#
# NOTE: When executed with Terraform, make sure the script has super user privileges.
# Run the command `sudo -s` beforehand.
#
# Author: Andrew Jarombek
# Date: 3/10/2019

bash <(curl -s global.jarombek.io/aws-key-gen.sh) $1