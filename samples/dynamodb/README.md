### Overview

DevOps Prototypes Sample DynamoDB infrastructure, code, and tests.  The workflow is:

1. Create Terraform Infrastructure
2. Run Infrastructure Tests
3. Run Application Code
4. Run Application Tests
5. Destroy Terraform Infrastructure

### Directories

| Directory Name   | Description                                                                    |
|------------------|--------------------------------------------------------------------------------|
| `app`            | Application code for working with and modifying DynamoDB tables/items.         |
| `infra`          | Terraform infrastructure configuration for DynamoDB.                           |
| `test`           | Tests for the Terraform created infrastructure and application code changes.   |

### Resources

1. [DynamoDB Table Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)
2. [DynamoDB Query and Scan](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStarted.Python.04.html)
3. [boto3 DynamoDB Scan Table](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html#DynamoDB.Table.scan)
4. [DynamoDB Secondary Indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SecondaryIndexes.html)