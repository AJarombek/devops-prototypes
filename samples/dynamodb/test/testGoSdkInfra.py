"""
Unit tests for the DynamoDB items created from the AWS Go SDK.
Author: Andrew Jarombek
Date: 2/25/2021
"""

import unittest
from typing import List

import boto3
from boto3.dynamodb.conditions import Key
from boto3_type_annotations.dynamodb import Table, ServiceResource


class TestTerraformInfra(unittest.TestCase):

    def setUp(self) -> None:
        """
        Perform set-up logic before executing any unit tests
        """
        self.dynamodb_resource: ServiceResource = boto3.resource('dynamodb')

    def test_scan_dynamodb_table(self):
        """
        Test that a scan of the DynamoDB table for stuffed animals returns all the items.
        """
        table: Table = self.dynamodb_resource.Table('stuffed-animals')
        response = table.scan()
        items: List[dict] = response.get('Items')

        self.assertEqual(5, len(items))
        names = [item.get('name') for item in items]
        self.assertIn('Lily', names)
        self.assertIn('Dotty', names)
        self.assertIn('Teddy', names)
        self.assertIn('Fluffy', names)
        self.assertIn('Spiky', names)

    def test_query_dynamodb_table_for_bears(self):
        """
        Test that a query of the DynamoDB table for stuffed animals returns a bear named Teddy.
        """
        table: Table = self.dynamodb_resource.Table('stuffed-animals')
        response = table.query(
            IndexName='NameIndex',
            KeyConditionExpression=Key('name').eq('Teddy'),
        )
        items: List[dict] = response.get('Items')
        self.assertEqual(1, len(items))

        teddy = items[0]
        self.assertEqual('Bear', teddy.get('species'))
        self.assertEqual(
            'The OG and forever loyal, Teddy always gives and asks for nothing in return.',
            teddy.get('description')
        )
        self.assertEqual('Teddy', teddy.get('name'))
        self.assertEqual(3, teddy.get('id'))


if __name__ == '__main__':
    unittest.main()

