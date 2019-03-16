### Overview

How to build a basic API infrastructure on AWS with AWS Lambda and API Gateway.  The infrastructure is stored as code 
with Terraform.  This code has a corresponding 
[Discovery Post](https://jarombek.com/blog/sep-7-2018-aws-lambda-api-gateway) on my website `jarombek.com`.

### Files

| Filename               | Description                                                                                |
|------------------------|--------------------------------------------------------------------------------------------|
| `lambda.tf`            | Terraform IaC for the AWS Lambda function and API Gateway.                                 |
| `lambdaPolicy.json`    | IAM Policy providing Invoke access to AWS Lambda functions.                                |
| `lambdaRole.json`      | IAM Assume Role policy for AWS Lambda and API Gateway.                                     |
| `request.vm`           | Velocity template for incoming API Gateway requests.                                       |
| `response.vm`          | Velocity template for outgoing API Gateway responses.                                      |
| `setup.sh`             | Bash script with basic Terraform commands.                                                 |
| `terraform.tfstate`    | Terraform state file which reflects which infrastructure is currently deployed.            |
| `toRomanNumeral.js`    | AWS Lambda function converting integers to roman numerals.                                 |
| `toRomanNumeral.zip`   | Zipped AWS Lambda function.                                                                |