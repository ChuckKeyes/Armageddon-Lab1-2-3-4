############################################
# Tokyo RDS (Medical Data Authority)
############################################

# DB Subnet Group (PRIVATE only)
resource "aws_db_subnet_group" "chewbacca_rds_subnet_group_tokyo" {
  name = "${var.project_name}-rds-subnet-group-tokyo"
  subnet_ids = [
    aws_subnet.chewbacca_private_subnet01.id,
    aws_subnet.chewbacca_private_subnet02.id
  ]


  tags = {
    Name        = "${var.project_name}-rds-subnet-group-tokyo"
    Environment = var.environment
  }
}

# RDS Instance
data "aws_rds_engine_version" "postgres_tokyo" {
  engine = "postgres"
  # optionally: version = "15" (depends on provider behavior)
}

# then in the DB instance:



resource "aws_db_instance" "chewbacca_rds_tokyo" {
  identifier     = "${var.project_name}-rds-tokyo"
  engine_version = data.aws_rds_engine_version.postgres_tokyo.version
  engine         = "postgres"
  # engine_version    = "15.5"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.rds_db_name
  username = var.rds_username
  password = var.rds_password

  db_subnet_group_name   = aws_db_subnet_group.chewbacca_rds_subnet_group_tokyo.name
  vpc_security_group_ids = [aws_security_group.chewbacca_rds_sg01.id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false

  backup_retention_period = 7
  backup_window           = "18:00-19:00"
  maintenance_window      = "sun:19:00-sun:20:00"

  tags = {
    Name        = "${var.project_name}-rds-tokyo"
    Environment = var.environment
    DataClass   = "PHI"
    Authority   = "Japan"
  }
}
