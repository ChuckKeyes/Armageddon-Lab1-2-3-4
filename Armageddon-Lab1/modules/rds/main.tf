locals { name_prefix = var.project_name }

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-rds-subnet-group01"
  subnet_ids = var.private_subnet_ids
  tags       = { Name = "${local.name_prefix}-rds-subnet-group01" }
}

resource "aws_db_instance" "this" {
  identifier             = "${local.name_prefix}-rds01"
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage

  db_name   = var.db_name
  username  = var.db_username
  password  = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = var.publicly_accessible
  skip_final_snapshot = var.skip_final_snapshot

  tags = { Name = "${local.name_prefix}-rds01" }
}
