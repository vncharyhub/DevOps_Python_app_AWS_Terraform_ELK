provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "devops-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags = { Name = "public-subnet" }
}

resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 0; to_port = 65535; protocol = "tcp"; cidr_blocks = ["0.0.0.0/0"]
  }
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "allow-all-sg" }
}

resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = { Name = "jenkins-server" }
}

resource "aws_ecr_repository" "app_repo" {
  name = "devops-app"
}

output "ecr_repo_url" { value = aws_ecr_repository.app_repo.repository_url }
output "jenkins_public_ip" { value = aws_instance.jenkins.public_ip }
