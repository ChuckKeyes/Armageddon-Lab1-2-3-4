# Explanation: Tokyo’s vault opens only to approved clinics—Liberdade gets DB access, the public gets nothing.
# resource "aws_security_group_rule" "shinjuku_rds_ingress_from_liberdade01" {
#   type              = "ingress"
#   security_group_id = aws_security_group.chewbacca_rds_sg01.id
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"

#   cidr_blocks = [var.sao_paulo_vpc_cidr]
#  # Sao Paulo VPC CIDR (students supply)
# }


############################################
# RDS Security Group (Tokyo)
############################################
resource "aws_security_group" "chewbacca_rds_sg01" {
  name        = "${var.project_name}-rds-sg01"
  description = "Tokyo RDS security group"
  vpc_id      = aws_vpc.chewbacca_vpc01.id

  tags = { Name = "${var.project_name}-tokyo-rds-sg01" }
}

# Allow Postgres from Sao Paulo VPC CIDR (via TGW routing)
resource "aws_security_group_rule" "shinjuku_rds_ingress_from_liberdade01" {
  type              = "ingress"
  security_group_id = aws_security_group.chewbacca_rds_sg01.id
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.sao_paulo_vpc_cidr]
}

# Outbound allowed (RDS usually needs this)
resource "aws_security_group_rule" "shinjuku_rds_egress_all01" {
  type              = "egress"
  security_group_id = aws_security_group.chewbacca_rds_sg01.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
