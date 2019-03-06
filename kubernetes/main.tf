/**
 * Infrastructure for creating a CloudFormation stack (needed to build EKS)
 * Author: Andrew Jarombek
 * Date: 3/4/2019
 */

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "andrew-jarombek-terraform-state"
    encrypt = true
    key = "sandbox/devops-prototypes/eks"
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

data "aws_subnet" "sandbox-subnet-0" {
  tags {
    Name = "Sandbox Subnet 0"
  }
}

data "aws_subnet" "sandbox-subnet-1" {
  tags {
    Name = "Sandbox Subnet 1"
  }
}

#-----------------------------
# New AWS CloudFormation Stack
#-----------------------------

resource "aws_cloudformation_stack" "eks-cf-stack" {
  name = "eks-cf-stack"
  template_body = "${file("template.yml")}"
  on_failure = "DELETE"
  timeout_in_minutes = 20

  parameters {
    VpcId = "${data.aws_vpc.sandbox-vpc.id}"
  }

  tags {
    Name = "eks-cf-stack"
  }
}