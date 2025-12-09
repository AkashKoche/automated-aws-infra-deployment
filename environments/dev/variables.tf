variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "The instance type for the application EC2 instances."
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "The desired number of EC2 instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "app_port" {
  description = "The port the application is running on inside the EC2 instance."
  type        = number
  default     = 3000
}

variable "jenkins_instance_type" {
  description = "The AWS EC2 instance type for the Jenkins server."
  type        = string
  default     = "t2.micro" 
}
