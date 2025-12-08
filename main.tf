terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "infrastructure" {
  source = "./environments/dev"
  
  environment         = var.environment
  aws_region          = var.aws_region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  demo_app_port        = var.demo_app_port
}
