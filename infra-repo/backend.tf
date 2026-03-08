terraform {
  backend "s3" {
    bucket         = "coolad-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "coolad-terraform-lock"
    encrypt        = true
  }
}
