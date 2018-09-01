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

resource "aws_api_gateway_rest_api" "roman-numeral-api" {
  # The name of the REST API
  name = "RomanNumeralAPI"

  # An optional description of the REST API
  description = "A Prototype REST API for Converting Integers to Roman Numerals"
}

resource "aws_api_gateway_resource" "roman-numeral-api-resource" {
  # The id of the associated REST API and parent API resource are required
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  parent_id = "${aws_api_gateway_rest_api.roman-numeral-api.root_resource_id}"

  # The last segment of the URL path for this API resource
  path_part = "roman-numeral"
}