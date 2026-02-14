resource "random_password" "db" {
  length  = 24
  special = true

  # Exclude characters RDS rejects: / @ " space
  override_special = "!#$%&'()*+,-.:;<=>?[]^_{|}~"
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.db_subnet_ids
  tags       = { Name = "${var.name}-db-subnets" }
}

resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "Allow Postgres from app"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "this" {
  identifier          = "${var.name}-pg"
  engine              = "postgres"
  engine_version      = "16" # adjust if needed
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  storage_encrypted   = true
  multi_az            = true
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  db_name  = var.db_name
  username = var.username
  password = random_password.db.result

  skip_final_snapshot = true # for labs; for prod set false + final snapshot
}
