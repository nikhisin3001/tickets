#!/bin/bash
# Set dummy AWS credentials for Terraform validation/testing
export AWS_ACCESS_KEY_ID="dummyaccesskey"
export AWS_SECRET_ACCESS_KEY="dummysecretkey"
export AWS_DEFAULT_REGION="us-east-1"
echo "Dummy AWS credentials set for this shell session."
