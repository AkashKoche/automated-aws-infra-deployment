output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public IPs of EC2 instances"
  value       = module.ec2.ec2_public_ips
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.ec2.alb_dns_name
}

output "jenkins_url" {
  description = "Jenkins server URL"
  value       = "http://${module.ec2.jenkins_public_ip}:8080"
}
