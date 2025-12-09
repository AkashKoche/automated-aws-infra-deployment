variable "aws" "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  decription = "Environment name"
  type       = string
  default    = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blcoks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"}
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 Instances"
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Port for Application"}
  type        = number
  default     = 3000
}
