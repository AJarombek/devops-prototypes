/**
 * Alter a DynamoDB table using the Go AWS SDK.
 * Author: Andrew Jarombek
 * Date: 2/17/2021
 */

package main

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

func main() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		panic("unable to load AWS SDK config, " + err.Error())
	}

	client := dynamodb.NewFromConfig(cfg)

	tableName := "stuffed-animals"
	input := &dynamodb.ScanInput{
		TableName: &tableName,
	}

	records, err := client.Scan(context.TODO(), input)

	if err != nil {
		panic("Table scan failed, " + err.Error())
	}

	if records.Count != 2 {
		panic("Dotty and Lily were not found in DynamoDB!  They must be busy napping.")
	}
}