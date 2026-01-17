locals { name_prefix = var.project_name }

resource "aws_security_group" "ec2" {
  name        = "${local.name_prefix}-ec2-sg01"
  description = "EC2 app security group"
  vpc_id      = var.vpc_id
  tags        = { Name = "${local.name_prefix}-ec2-sg01" }
}

resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg01"
  description = "RDS security group"
  vpc_id      = var.vpc_id
  tags        = { Name = "${local.name_prefix}-rds-sg01" }
}

# HTTP 80 from anywhere (basic lab default)
resource "aws_security_group_rule" "ec2_http_in" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# SSH 22 only from your IP (optional)
resource "aws_security_group_rule" "ec2_ssh_in" {
  count             = var.my_ip_cidr != "" ? 1 : 0
  type              = "ingress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip_cidr]
}

# Allow EC2 -> RDS (MySQL)
resource "aws_security_group_rule" "rds_mysql_in_from_ec2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2.id
}

# Egress (allow all) - simple lab default
resource "aws_security_group_rule" "ec2_all_out" {
  type              = "egress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_all_out" {
  type              = "egress"
  security_group_id = aws_security_group.rds.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
