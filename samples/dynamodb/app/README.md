### Overview

Scripts which use the AWS Go SDK to add and remove items from a DynamoDB table.  It also scans the DynamoDB table to 
ensure that the items are added and removed properly.

### Commands

*First Time Setup*

```bash
go version
go mod init dynamodb-sample 
go get github.com/aws/aws-sdk-go-v2
go get github.com/aws/aws-sdk-go-v2/config
go get github.com/aws/aws-sdk-go-v2/service/dynamodb
```

*Run the Code Locally*

```bash
export AWS_REGION=us-east-1
go run main.go
```

### Files

| Filename        | Description                                                                             |
|-----------------|-----------------------------------------------------------------------------------------|
| `main.go`       | Go script which uses the AWS SDK to scan a DynamoDB table add add/remove items.         |
| `go.mod`        | Go module definition and dependency specification.                                      |
| `go.sum`        | Versions of modules installed as dependencies for this Go module.                       |