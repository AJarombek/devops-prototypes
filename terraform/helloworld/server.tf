/*
 * Author: Andrew Jarombek
 * Date: 7/31/2018
 * A "Hello World" type of Terraform configuration
 */

# Define some input variables for the Terraform configuration.
# The description is used as documentation for the vairable.
# If no value is passed in to a variable when invoking Terraform from the command line,
# the default value is used.  If no type is included, Terraform will guess the type based
# on the default value.
variable "region" {
  description = "The region in AWS for the EC2 Instance"
  default = "us-east-1"
  type = "string"
}

variable "instance_type" {
  description = "The instance type (size of the instance)"
  default = "t2.micro"
}

variable "ami" {
  description = "The Amazon Machine Image for the instance"
  default = "ami-04169656fea786776"
}

variable "server_port" {
  description = "The server port to use for the basic web server"
  default = 8080
}

# Set up the provider - the service to deploy infrastructure to
provider "aws" {
  region = "${var.region}"
}

# Each provider has a bunch of different resources that you can create
# the aws_instance resource creates a new EC2 instance on AWS
resource "aws_instance" "tf-basic-instance" {
  # Just a random Linux AMI I found on the Amazon AMI Marketplace
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.instance_security.id}"]

  # Define user_data which will execute while the instance is booting up
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello From Terraform" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "tf-basic-instance"
  }
}

# Creates a new elastic IP address for an application.  If an instance fails, the IP
# address will simply be remapped to the new instance.
resource "aws_eip" "tf-instance-ip" {
  instance = "${aws_instance.tf-basic-instance.id}"

  # You can define explicit dependencies to make sure terraform processes resources in order,
  # However terraform handles dependencies behind the scenes implicitly.  So this is redundant.
  depends_on = ["aws_instance.tf-basic-instance"]
}

# Creates a new security group for the EC2 instance - this is necessary because EC2 instances
# do not allow incoming traffic by default
resource "aws_security_group" "instance_security" {
  name = "tf-basic-instance"

  # Handle incomming traffic
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"

    # IP Range - allow all incomming IP addresses
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define output variables which will be listed after terraform changes are applied
output "public_ip" {
  value = "${aws_instance.tf-basic-instance.public_ip}"
}

output "elastic_ip" {
  value = "${aws_eip.tf-instance-ip.public_ip}"
}