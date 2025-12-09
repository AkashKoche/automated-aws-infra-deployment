variable "environment" {
  description = "The environment name for tagging (e.g., dev)."
  type        = string
}

variable "jenkins_instance_type" {
  description = "The instance type for the Jenkins server."
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the Jenkins server will be deployed."
  type        = string
}

variable "jenkins_security_group_id" {
  description = "The ID of the security group to assign to the Jenkins server."
  type        = string
}
