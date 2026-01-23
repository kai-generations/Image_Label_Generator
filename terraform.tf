terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }
  # Terraform version 
  required_version = ">= 1.14.0"
}