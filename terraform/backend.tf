terraform {
  backend "s3" {
    bucket = "user-terraform-state-files"
    key    = "terraform\terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
