#!/bin/bash
# Build and push Docker image to ECR
ECR_URL=$1
if [ -z "$ECR_URL" ]; then
  echo "Usage: $0 <ecr-repo-url>"
  exit 1
fi

eval $(aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin "$ECR_URL")
docker build -t fastapi-app ..
docker tag fastapi-app:latest "$ECR_URL":latest
docker push "$ECR_URL":latest
