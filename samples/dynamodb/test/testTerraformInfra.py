"""
Unit tests for the DynamoDB infrastructure & table items created by Terraform.
Author: Andrew Jarombek
Date: 2/14/2021
"""

import unittest
from typing import List

import boto3
from boto3.dynamodb.types import Decimal
from boto3_type_annotations.dynamodb import Client, Table, ServiceResource


class TestTerraformInfra(unittest.TestCase):

    def setUp(self) -> None:
        """
        Perform set-up logic before executing any unit tests
        """
        self.dynamodb_client: Client = boto3.client('dynamodb')
        self.dynamodb_resource: ServiceResource = boto3.resource('dynamodb')

    def test_dynamodb_table_exists_as_expected(self):
        """
        Test that a DynamoDB table for stuffed animals exists as expected.
        """
        table_info = self.dynamodb_client.describe_table(TableName='stuffed-animals')
        table: dict = table_info.get('Table')

        self.assertEqual('stuffed-animals', table.get('TableName'))
        self.assertEqual('ACTIVE', table.get('TableStatus'))

        attributes = table.get('AttributeDefinitions')
        self.assertEqual(3, len(attributes))
        self.assertEqual('id', attributes[0].get('AttributeName'))
        self.assertEqual('N', attributes[0].get('AttributeType'))
        self.assertEqual('name', attributes[1].get('AttributeName'))
        self.assertEqual('S', attributes[1].get('AttributeType'))
        self.assertEqual('species', attributes[2].get('AttributeName'))
        self.assertEqual('S', attributes[2].get('AttributeType'))

        self.assertEqual(1, len(table.get('KeySchema')))
        key_attribute = table.get('KeySchema')[0]
        self.assertEqual('id', key_attribute.get('AttributeName'))
        self.assertEqual('HASH', key_attribute.get('KeyType'))

        self.assertEqual(1, len(table.get('GlobalSecondaryIndexes')))
        secondary_index = table.get('GlobalSecondaryIndexes')[0]
        self.assertEqual('NameIndex', secondary_index.get('IndexName'))

        secondary_index_hash_key = secondary_index.get('KeySchema')[0]
        self.assertEqual('name', secondary_index_hash_key.get('AttributeName'))
        self.assertEqual('HASH', secondary_index_hash_key.get('KeyType'))

        secondary_index_range_key = secondary_index.get('KeySchema')[1]
        self.assertEqual('species', secondary_index_range_key.get('AttributeName'))
        self.assertEqual('RANGE', secondary_index_range_key.get('KeyType'))

    def test_scan_dynamodb_table(self):
        """
        Test that a scan of the DynamoDB table for stuffed animals returns all the items.
        """
        table: Table = self.dynamodb_resource.Table('stuffed-animals')
        response = table.scan()
        items: List[dict] = response.get('Items')

        self.assertEqual(2, len(items))

        lily = items[0]
        self.assertEqual('Bear', lily.get('species'))
        self.assertEqual('A pillow pet who likes to hang out with Dotty, hibernate, and watch Packers games.', lily.get('description'))
        self.assertEqual('Lily', lily.get('name'))
        self.assertEqual(Decimal(2), lily.get('id'))

        dotty = items[1]
        self.assertEqual('Horse', dotty.get('species'))
        self.assertEqual('Small spotted horse who loves to cuddle.  She also has beautiful flappy ears.', dotty.get('description'))
        self.assertEqual('Dotty', dotty.get('name'))
        self.assertEqual(Decimal(1), dotty.get('id'))


if __name__ == '__main__':
    unittest.main()
