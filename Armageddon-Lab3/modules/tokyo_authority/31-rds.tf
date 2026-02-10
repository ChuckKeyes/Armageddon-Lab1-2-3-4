######################################################
############################################
# 31-rds.tf (Tokyo)
# RDS + DB subnet group + SG + Secrets Manager
############################################

############################
# DB Subnet Group (PRIVATE subnets)
############################
resource "aws_db_subnet_group" "tokyo_db_subnet_group" {
  name       = "${var.name_prefix}-tokyo-db-subnet-group"
  subnet_ids = local.tokyo_private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-db-subnet-group"
  })
}

############################
# RDS Security Group (3306 only from EC2 SG)
############################
resource "aws_security_group" "tokyo_rds_sg" {
  name        = "${var.name_prefix}-tokyo-rds-sg"
  description = "RDS SG: allow MySQL only from app EC2 SG"
  vpc_id      = local.tokyo_vpc_id

  ingress {
    description     = "MySQL from app EC2 SG only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.tokyo_ec2_app_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-rds-sg"
  })
}

############################
# Secrets Manager (initially store username/password/dbname)
# Then we populate host/port after RDS exists.
############################
# resource "aws_secretsmanager_secret" "tokyo_db_secret" {
#   name                    = "${var.name_prefix}/tokyo/rds"
#   recovery_window_in_days = 0

#   tags = merge(var.tags, {
#     Name = "${var.name_prefix}-tokyo-db-secret"
#   })
# }

# Create RDS first so we can write host/port into the secret version.
# Terraform can still do this in one apply.
resource "aws_db_instance" "tokyo_rds" {
  identifier = "${var.name_prefix}-tokyo-rds"

  engine         = "mysql"
  engine_version = var.rds_engine_version

  instance_class = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 3306

  # Private DB
  publicly_accessible = false
  multi_az            = var.rds_multi_az
  storage_encrypted   = true
  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot
  apply_immediately   = true

  db_subnet_group_name   = aws_db_subnet_group.tokyo_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.tokyo_rds_sg.id]

  # Optional: set if you use a custom parameter group
  # parameter_group_name = var.rds_parameter_group_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-rds"
    Role = "db"
  })
}

# Now write full connection JSON including host/port
# resource "aws_secretsmanager_secret_version" "tokyo_db_secret_version" {
#   secret_id = aws_secretsmanager_secret.tokyo_db_secret.id

#   secret_string = jsonencode({
#     username = var.db_username
#     password = var.db_password
#     dbname   = var.db_name
#     host     = aws_db_instance.tokyo_rds.address
#     port     = aws_db_instance.tokyo_rds.port
#   })
# }
