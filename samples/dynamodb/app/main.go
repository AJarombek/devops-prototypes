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
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
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

	teddy := map[string]types.AttributeValue{
		"id": &types.AttributeValueMemberN{Value: "3"},
		"name": &types.AttributeValueMemberS{Value: "Teddy"},
		"species": &types.AttributeValueMemberS{Value: "Bear"},
		"description": &types.AttributeValueMemberS{
			Value: "The OG and forever loyal, Teddy always gives and asks for nothing in return.",
		},
	}

	putInput := &dynamodb.PutItemInput{
		TableName: &tableName,
		Item: teddy,
	}

	_, err = client.PutItem(context.TODO(), putInput)

	if err != nil {
		panic("Failed to create a new item in DynamoDB.")
	}

	fluffy := map[string]types.AttributeValue{
		"id": &types.AttributeValueMemberN{Value: "4"},
		"name": &types.AttributeValueMemberS{Value: "Fluffy"},
		"species": &types.AttributeValueMemberS{Value: "Goat"},
		"description": &types.AttributeValueMemberS{
			Value: "Retired daredevil, Fluffy now enjoys relaxing under a warm blanket.",
		},
	}

	spiky := map[string]types.AttributeValue{
		"id": &types.AttributeValueMemberN{Value: "5"},
		"name": &types.AttributeValueMemberS{Value: "Spiky"},
		"species": &types.AttributeValueMemberS{Value: "Goat"},
		"description": &types.AttributeValueMemberS{
			Value: "Little brother of Fluffy.",
		},
	}

	grandmasBlanket := map[string]types.AttributeValue{
		"id": &types.AttributeValueMemberN{Value: "6"},
		"name": &types.AttributeValueMemberS{Value: "Grandma's Blanket"},
		"species": &types.AttributeValueMemberS{Value: "Blanket"},
		"description": &types.AttributeValueMemberS{
			Value: "Does Grandma's blanket qualify as a stuffed animal?  The debate rages on.",
		},
	}

	fluffyPutRequest := types.PutRequest{
		Item: fluffy,
	}

	spikyPutRequest := types.PutRequest{
		Item: spiky,
	}

	grandmasBlanketPutRequest := types.PutRequest{
		Item: grandmasBlanket,
	}

	writeRequest := map[string][]types.WriteRequest{
		tableName: {
			{ PutRequest: &fluffyPutRequest },
			{ PutRequest: &spikyPutRequest },
			{ PutRequest: &grandmasBlanketPutRequest },
		},
	}

	batchWriteInput := &dynamodb.BatchWriteItemInput{
		RequestItems: writeRequest,
	}

	_, err = client.BatchWriteItem(context.TODO(), batchWriteInput)

	if err != nil {
		panic("Failed to create new items in DynamoDB (bulk insert).")
	}
}