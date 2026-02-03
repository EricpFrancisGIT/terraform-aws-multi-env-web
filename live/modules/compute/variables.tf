variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "desired" { type = number }
variable "alb_sg_id" {
  type = string
}
variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GB"
}
