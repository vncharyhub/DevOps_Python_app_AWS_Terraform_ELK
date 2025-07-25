
terraform {
  backend "s3" {
    bucket         = "my-state-files"
    key            = "ec2-custom-vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
