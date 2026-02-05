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
variable "existing_instance_profile_name" {
  type        = string
  description = "Existing IAM instance profile name to attach to EC2 instances (for SSM)"
  default     = ""
}
