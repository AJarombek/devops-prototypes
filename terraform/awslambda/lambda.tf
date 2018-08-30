/*
 * Author: Andrew Jarombek
 * Date: 8/29/2018
 * A Terraform configuration for an AWS Lambda function
 */

provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "to-roman-numberal-js" {
  # The local file to use as the lambda function.  A popular alternative is to keep the lambda function
  # source code in an S3 bucket.
  filename = "toRomanNumeral.zip"

  # A unique name to give the lambda function.
  function_name = "ToRomanNumberalJs"

  # The entrypoint to the lambda function in the source code.  The format is <file-name>.<property-name>
  handler = "toRomanNumeral.handler"

  # IAM (Identity and Access Management) policy for the lambda function.
  role = "${aws_iam_role.lambda-role.arn}"

  # Use Node.js for this lambda function.
  runtime = "nodejs8.10"
}

resource "aws_iam_role" "lambda-role" {
  name = "iam-lambda-role"
  assume_role_policy = "${file("lambdaRole.json")}"
}