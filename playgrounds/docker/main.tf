/**
 * Infrastructure creating a Docker playground environment on AWS.
 * Author: Andrew Jarombek
 * Date: 3/6/2019
 */

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "andrew-jarombek-terraform-state"
    encrypt = true
    key = "sandbox/devops-prototypes/docker-playground"
    region = "us-east-1"
  }
}

#-----------------------
# Existing AWS Resources
#-----------------------

data "aws_vpc" "sandbox-vpc" {
  tags {
    Name = "sandbox-vpc"
  }
}

data "aws_subnet" "sandbox-subnet" {
  tags {
    Name = "sandbox-vpc-fearless-public-subnet"
  }
}

#--------------------------------------
# Executed Before Resources are Created
#--------------------------------------

resource "null_resource" "key-gen" {
  provisioner "local-exec" {
    command = "bash key-gen.sh"
  }
}

#-----------------------------
# New AWS CloudFormation Stack
#-----------------------------

resource "aws_cloudformation_stack" "docker-playground-cf-stack" {
  name = "docker-playground-cf-stack"
  template_body = "${file("docker-playground.yml")}"
  on_failure = "DELETE"
  timeout_in_minutes = 20

  parameters {
    VpcId = "${data.aws_vpc.sandbox-vpc.id}"
    SubnetId = "${data.aws_subnet.sandbox-subnet.id}"
  }

  tags {
    Name = "docker-playground-cf-stack"
  }

  depends_on = ["null_resource.key-gen"]
}