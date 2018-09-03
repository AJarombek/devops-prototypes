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

# Set permissions on the lambda function, allowing API Gateway to invoke the function
resource "aws_lambda_permission" "allow_api_gateway" {
  # The action this permission allows is to invoke the function
  action = "lambda:InvokeFunction"

  # The name of the lambda function to attach this permission to
  function_name = "${aws_lambda_function.to-roman-numberal-js.arn}"

  # An optional identifier for the permission statement
  statement_id = "AllowExecutionFromApiGateway"

  # The item that is getting this lambda permission
  principal = "apigateway.amazonaws.com"

  # /*/*/* sets this permission for all stages, methods, and resource paths in API Gateway to the lambda
  # function. - https://bit.ly/2NbT5V5
  source_arn = "${aws_api_gateway_rest_api.roman-numeral-api.execution_arn}/*/*/*"
}

# Create an IAM role for the lambda function
resource "aws_iam_role" "lambda-role" {
  name = "iam-lambda-role"
  assume_role_policy = "${file("lambdaRole.json")}"
}

# Create an IAM policy for a role
# This isnt necessary for the current configuration, although it is good to see how a policy can be attached
resource "aws_iam_role_policy" "lambda-policy" {
  name = "iam-lambda-policy"
  role = "${aws_iam_role.lambda-role.id}"
  policy = "${file("lambdaPolicy.json")}"
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

  # AWS is used for Lambda proxy integration when you want to use a Velocity template
  type = "AWS"

  # The URI at which the API is invoked
  uri = "${aws_lambda_function.to-roman-numberal-js.invoke_arn}"

  # Lambda functions can only be invoked via HTTP POST - https://amzn.to/2owMYNh
  integration_http_method = "POST"

  # Configure the Velocity request template for the application/json MIME type
  request_templates {
    "application/json" = "${file("request.vm")}"
  }
}

# Create an HTTP method response for the aws lambda integration
resource "aws_api_gateway_method_response" "lambda-api-method-response" {
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"
  http_method = "${aws_api_gateway_method.integer-to-roman-numeral-method.http_method}"
  status_code = "200"
}

# Configure the API Gateway and Lambda functions response
resource "aws_api_gateway_integration_response" "lambda-api-integration-response" {
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"
  http_method = "${aws_api_gateway_method.integer-to-roman-numeral-method.http_method}"

  status_code = "${aws_api_gateway_method_response.lambda-api-method-response.status_code}"

  # Configure the Velocity response template for the application/json MIME type
  response_templates {
    "application/json" = "${file("response.vm")}"
  }
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