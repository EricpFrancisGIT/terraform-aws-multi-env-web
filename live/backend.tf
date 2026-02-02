terraform {
  backend "s3" {
    bucket         = "eric-tf-state-20260201-v1"
    key            = "multi-env-web/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
