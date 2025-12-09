variable "key_name" {
  description = "The name of the key pair to use for SSH access to EC2 instances."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the Target Group to attach the EC2 instances to."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC created by the VPC module."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of Public Subnet IDs for the Application Load Balancer."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_ids" {
  description = "A list of Private Subnet IDs where the application EC2 instances will run."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "alb_security_group_id" {
  description = "The Security Group ID for the Application Load Balancer."
  type        = string
}

variable "ec2_security_group_id" {
  description = "The Security Group ID for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the application servers (e.g., t2.micro)."
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

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod) for resource tagging."
  type        = string
}
