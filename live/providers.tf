provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "tf-multi-env-web"
      Owner   = "Eric"
      Env     = terraform.workspace
    }
  }
}
