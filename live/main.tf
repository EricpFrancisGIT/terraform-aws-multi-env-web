module "vpc" {
  source = "./modules/vpc"

  name = "${var.project_name}-${local.env}"
  cidr = local.vpc_cidr
}

module "compute" {
  source = "./modules/compute"

  name          = "${var.project_name}-${local.env}"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.public_subnet_ids
  instance_type = local.instance_type
  desired       = local.desired_capacity

  alb_sg_id        = module.alb.alb_sg_id
  root_volume_size = local.root_volume_size
}

module "alb" {
  source = "./modules/alb"

  name       = "${var.project_name}-${local.env}"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

resource "aws_autoscaling_attachment" "asg_to_tg" {
  autoscaling_group_name = module.compute.asg_name
  lb_target_group_arn    = module.alb.target_group_arn
}
