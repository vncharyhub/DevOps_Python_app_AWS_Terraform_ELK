# Output ECR repository URL
output "ecr_repo_url" {
  description = "The URL of the ECR repository for Docker images"
  value       = aws_ecr_repository.app_repo.repository_url
}

# Output Jenkins EC2 public IP
output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

# Output Jenkins EC2 instance ID
output "jenkins_instance_id" {
  description = "The EC2 instance ID of the Jenkins server"
  value       = aws_instance.jenkins.id
}

# Output VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}
