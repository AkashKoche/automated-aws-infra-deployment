output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins server."
  value       = aws_instance.jenkins.public_ip
}

output "key_pair_name" {
  description = "The name of the SSH key pair created for instance access."
  value       = aws_key_pair.app.key_name
}
