output "env" {
  value = terraform.workspace
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "asg_name" {
  value = module.compute.asg_name
}

output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "web_sg_id" {
  value = module.compute.web_sg_id
}
