output "alb_security_group_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "Security group ID for EC2 instances"
  value       = aws_security_group.ec2.id
}

output "jenkins_security_group_id" {
  description = "The ID of the Jenkins Server Security Group."
  value       = aws_security_group.jenkins.id
}
