#!/bin/bash
set -e

set -a
source .env
set +a

FILE=$1

aws --endpoint-url=$ENDPOINT s3 cp "$FILE" s3://$BUCKET_NAME/
