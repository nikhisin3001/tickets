variable "aws_region" {
  description = "AWS region to deploy resources in."
  default     = "us-east-1"
}

variable "db_username" {
  description = "Database master username."
  type        = string
}

variable "db_password" {
  description = "Database master password."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name."
  default     = "fastapi_db"
}
