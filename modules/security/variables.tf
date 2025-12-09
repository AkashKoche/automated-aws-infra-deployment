variable "environment" {
  description = "The environment name (e.g., dev, staging, prod) for resource tagging."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC used to create the Security Groups within."
  type        = string
}

variable "app_port" {
  description = "The application port to allow inbound traffic on EC2 instances."
  type        = number
  default     = 3000
}
