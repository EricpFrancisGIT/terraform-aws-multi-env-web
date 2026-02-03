locals {
  env = terraform.workspace

  vpc_cidr = local.env == "prod" ? "10.20.0.0/16" : "10.10.0.0/16"

  instance_type = local.env == "prod" ? "t3.small" : "t3.micro"

  desired_capacity = local.env == "prod" ? 2 : 1

  root_volume_size = terraform.workspace == "prod" ? 50 : 30
}
