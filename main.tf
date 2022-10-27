terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # backend "s3" {
  # bucket = "${var.company}-${var.project}-${var.environment}"
  # key    = "terraform-test.tfstate"
  # region = "var.aws_region"
  # }
}

# Configure the AWS Provider
provider "aws" {
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  # region     = var.aws_region
}