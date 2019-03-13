/**
 * Infrastructure creating a Kubernetes playground environment on AWS.
 * Author: Andrew Jarombek
 * Date: 3/6/2019
 */

locals {
  my_cidr = "69.124.72.192/32"
  public_cidr = "0.0.0.0/0"
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "andrew-jarombek-terraform-state"
    encrypt = true
    key = "sandbox/devops-prototypes/kubernetes-playground"
    region = "us-east-1"
  }
}

#-----------------------
# Existing AWS Resources
#-----------------------

data "aws_region" "current-region" {}

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

data "template_file" "user-data-template" {
  template = "${file("user-data.sh")}"

  vars {
    STACK_NAME = "kubernetes-playground-cf-stack"
    REGION = "${data.aws_region.current-region.name}"
  }
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

#--------------------------------------
# Executed Before Resources are Created
#--------------------------------------

resource "null_resource" "key-gen" {
  provisioner "local-exec" {
    command = "bash ../key-gen.sh sandbox-kubernetes-playground-key"
  }
}

#-----------------------------
# New AWS CloudFormation Stack
#-----------------------------

resource "aws_cloudformation_stack" "kubernetes-playground-cf-stack" {
  name = "kubernetes-playground-cf-stack"
  template_body = "${file("kubernetes-playground.yml")}"
  on_failure = "DELETE"
  timeout_in_minutes = 20

  parameters {
    VpcId = "${data.aws_vpc.sandbox-vpc.id}"
    SubnetId = "${data.aws_subnet.sandbox-subnet.id}"
    MyCidr = "${local.my_cidr}"
    PublicCidr = "${local.public_cidr}"
    AMI = "${data.aws_ami.ubuntu-ami.image_id}"
    UserData = "${data.template_file.user-data-template.rendered}"
  }

  tags {
    Name = "kubernetes-playground-cf-stack"
  }

  depends_on = ["null_resource.key-gen"]
}