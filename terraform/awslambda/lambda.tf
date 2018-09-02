/*
 * Author: Andrew Jarombek
 * Date: 8/29/2018
 * A Terraform configuration for an AWS Lambda function
 */

provider "aws" {
  region = "us-east-1"
}

# A data source containing the lambda function
data "archive_file" "lambda" {
  source_file = "toRomanNumeral.js"
  type = "zip"
  output_path = "toRomanNumeral.zip"
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

  # The source code hash is used by Terraform to detect whether the source code of the lambda function
  # has changed.  If it changed, Terraform will re-upload the lambda function.
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
}

# Create an IAM policy for the lambda function
resource "aws_iam_role" "lambda-role" {
  name = "iam-lambda-role"
  assume_role_policy = "${file("lambdaRole.json")}"
}

# Declare a new API Gateway REST API
resource "aws_api_gateway_rest_api" "roman-numeral-api" {
  # The name of the REST API
  name = "RomanNumeralAPI"

  # An optional description of the REST API
  description = "A Prototype REST API for Converting Integers to Roman Numerals"
}

# Create an API Gateway resource, which is a certain path inside the REST API
resource "aws_api_gateway_resource" "roman-numeral-api-resource" {
  # The id of the associated REST API and parent API resource are required
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  parent_id = "${aws_api_gateway_rest_api.roman-numeral-api.root_resource_id}"

  # The last segment of the URL path for this API resource
  path_part = "roman-numeral"
}

resource "aws_api_gateway_resource" "integer-api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  parent_id = "${aws_api_gateway_resource.roman-numeral-api-resource.id}"

  path_part = "{integer}"
}

# Provide an HTTP method to a API Gateway resource (REST endpoint)
resource "aws_api_gateway_method" "integer-to-roman-numeral-method" {
  # The ID of the REST API and the resource at which the API is invoked
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"

  # The verb of the HTTP request
  http_method = "GET"

  # Whether any authentication is needed to call this endpoint
  authorization = "NONE"
}

# Integrate API Gateway REST API with a Lambda function
resource "aws_api_gateway_integration" "lambda-api-integration" {
  # The ID of the REST API and the endpoint at which to integrate a Lambda function
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"

  # The HTTP method to integrate with the Lambda function
  http_method = "${aws_api_gateway_method.integer-to-roman-numeral-method.http_method}"

  # AWS_PROXY is used for Lambda proxy integration - https://bit.ly/2wy8R2S
  type = "AWS_PROXY"

  # The URI ay which the API is invoked
  uri = "${aws_lambda_function.to-roman-numberal-js.invoke_arn}"

  # Lambda functions can only be invoked via HTTP POST - https://amzn.to/2owMYNh
  integration_http_method = "POST"
}

# Create a new API Gateway deployment
resource "aws_api_gateway_deployment" "roman-numeral-api-dev-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"

  # development stage
  stage_name = "dev"

  # Remove race conditions - deployment should always occur after lambda integration
  depends_on = [
    "aws_api_gateway_integration.lambda-api-integration"
  ]
}

# URL to invoke the API
output "url" {
  value = "${aws_api_gateway_deployment.roman-numeral-api-dev-deployment.invoke_url}"
}