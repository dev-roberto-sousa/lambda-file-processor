#!/bin/bash
set -e

set -a
source .env
set +a

aws --endpoint-url=$ENDPOINT s3 mb s3://$BUCKET_NAME

aws --endpoint-url=$ENDPOINT dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=filename,AttributeType=S \
  --key-schema AttributeName=filename,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region $REGION

cd lambda
zip function.zip lambda_function.py
cd ..

aws --endpoint-url=$ENDPOINT lambda create-function \
  --function-name $FUNCTION_NAME \
  --runtime python3.8 \
  --handler lambda_function.handler \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --zip-file fileb://lambda/function.zip \
  --region $REGION \
  --environment Variables="{S3_ENDPOINT=$ENDPOINT,DYNAMODB_ENDPOINT=$ENDPOINT}"

aws --endpoint-url=$ENDPOINT lambda add-permission \
  --function-name $FUNCTION_NAME \
  --statement-id s3invoke \
  --action "lambda:InvokeFunction" \
  --principal s3.amazonaws.com \
  --source-arn arn:aws:s3:::$BUCKET_NAME \
  --region $REGION

aws --endpoint-url=$ENDPOINT s3api put-bucket-notification-configuration \
  --bucket $BUCKET_NAME \
  --notification-configuration "{
    \"LambdaFunctionConfigurations\": [{
      \"LambdaFunctionArn\": \"arn:aws:lambda:$REGION:000000000000:function:$FUNCTION_NAME\",
      \"Events\": [\"s3:ObjectCreated:*\"]
    }]
  }" \
  --region $REGION
