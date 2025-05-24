provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "<your-terraform-state-bucket>"   # TODO: Replace with your S3 bucket name
    key            = "terraform.tfstate"
    region         = "<your-aws-region>"               # TODO: Replace with your AWS region (e.g., us-east-1)
    dynamodb_table = "<your-lock-table>"               # TODO: (Optional) Replace with your DynamoDB table for state locking
    encrypt        = true
  }
}
