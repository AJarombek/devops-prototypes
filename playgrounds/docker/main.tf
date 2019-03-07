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
    Name = "Sandbox VPC"
  }
}

data "aws_subnet" "sandbox-subnet" {
  tags {
    Name = "fearless-sandbox-public-subnet"
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
}