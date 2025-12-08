terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " "~> 5.0""
    }
  }


  backend "s3" {
    bucket            = "terraform-state-bucket-akashkoche"
    key               = "terraform.tfstate"
    region            = "us-east-1"
    dynamodb_table    = "terraform-state-lock"
    encrypt           = true
  }
}

provider "aws" {
  region = var.aws_region
}

