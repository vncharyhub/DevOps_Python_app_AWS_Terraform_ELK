variable "aws_region" {
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances (Ubuntu)"
  default     = "ami-0c94855ba95c71c99"
}
