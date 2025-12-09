variable "key_name" {
  description = "The name of the key pair to use for SSH access to EC2 instances."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the Target Group to attach the EC2 instances to."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of Private Subnet IDs where the application EC2 instances will run."
  type        = list(string)
  # Default value should be removed from module variables in favor of root variables
}

variable "ec2_security_group_id" {
  description = "The Security Group ID for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the application servers (e.g., t2.micro)."
  type        = string
}

variable "instance_count" {
  description = "The desired number of EC2 instances in the Auto Scaling Group."
  type        = number
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod) for resource tagging."
  type        = string
}
