data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]


  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_security_group" "web" {
  name        = "${var.name}-web-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web.id]

  # ✅ Enforce IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # ✅ Encrypt root volume (EBS)
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted             = true
      volume_type           = "gp3"
      volume_size           = var.root_volume_size
      delete_on_termination = true
    }
  }

  # ✅ Harden user_data: fail fast, log output, ensure service is running
  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y httpd

systemctl enable httpd
echo "<h1>${var.name} (${terraform.workspace})</h1>" > /var/www/html/index.html
systemctl restart httpd

# Helpful debug log location:
# /var/log/cloud-init-output.log
EOF
  )
}


resource "aws_autoscaling_group" "this" {
  name                = "${var.name}-asg"
  desired_capacity    = var.desired
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # ✅ Use ALB health checks
  health_check_type         = "ELB"
  health_check_grace_period = 120

  termination_policies = ["OldestLaunchTemplate", "OldestInstance"]

  # ✅ Rolling replacements on LT changes
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 120
    }


  }

  lifecycle {
    create_before_destroy = true
  }
}
