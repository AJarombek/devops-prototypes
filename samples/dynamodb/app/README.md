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