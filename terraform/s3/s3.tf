/*
 * Configuring a basic AWS S3 bucket with Terraform
 * Author: Andrew Jarombek
 * Date: 9/4/2018
 */

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "test_bucket" {
  # Bucket name must be unique across all AWS users!
  # https://github.com/hashicorp/terraform/issues/2774#issuecomment-195479501
  bucket = "jarbek-terraform-test-bucket"

  # Nobody has write access to the bucket except for the owner.  However, anyone can read
  # the endpoints of the bucket.  ACL = Access Control List
  acl = "public-read"

  tags {
    Name = "Terraform Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "picture" {
  bucket = "${aws_s3_bucket.test_bucket.id}"
  key = "pouring_rain"
  source = "meet_me_in.jpg"
  etag = "${md5(file("meet_me_in.jpg"))}"
}