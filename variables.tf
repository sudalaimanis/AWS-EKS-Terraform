variable "aws_region" {
  description = "The AWS region to deploy resources in."
  default     = "us-east-1"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  default     = "staging"
}

variable "project_name" {
  description = "The name of the project for resource naming."
  default     = "dumbledore-army-eks"
}
