import os
import json
import boto3

def handler(event, context):
    s3_endpoint = os.environ.get("S3_URL")
    dynamodb_url = os.environ.get("DYNAMODB_URL")

    s3 = boto3.client('s3', endpoint_url=s3_endpoint)
    dynamodb = boto3.resource('dynamodb', endpoint_url=dynamodb_url)

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        metadata = {
            'filename': key,
            'bucket': bucket,
        }

        table = dynamodb.Table('FilesMetadata')
        table.put_item(Item=metadata)

    return {"statusCode": 200, "body": json.dumps("Processed")}
