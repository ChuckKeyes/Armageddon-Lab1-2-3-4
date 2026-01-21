data "aws_caller_identity" "self" {}
data "aws_region" "current" {}

locals {
  name_prefix = var.project_name
  common_tags = merge({ Project = var.project_name }, var.tags)
}

############################################
# SG for Interface Endpoints
############################################
resource "aws_security_group" "vpce_sg" {
  name        = "${local.name_prefix}-vpce-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-vpce-sg" })
}

# Allow HTTPS from EC2 SG -> endpoint ENIs
resource "aws_security_group_rule" "vpce_https_from_ec2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.vpce_sg.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.ec2_security_group_id
  description              = "Allow 443 from EC2 SG to interface endpoints"
}

############################################
# VPC Endpoint - S3 (Gateway)
############################################
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-vpce-s3-gw" })
}

############################################
# VPC Endpoints - Interface
############################################
locals {
  interface_services = toset([
    "ssm",
    "ec2messages",
    "ssmmessages",
    "logs",
    "secretsmanager",
    "kms"
  ])
}

resource "aws_vpc_endpoint" "interface" {
  for_each            = local.interface_services
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.id}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpce_sg.id]

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-vpce-${each.key}" })
}

############################################
# Optional: Private EC2 (no public IP)
############################################
resource "aws_instance" "private" {
  count                 = var.create_private_instance ? 1 : 0
  ami                   = var.ec2_ami_id
  instance_type         = var.ec2_instance_type
  subnet_id             = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.ec2_security_group_id]
  iam_instance_profile  = var.iam_instance_profile_name

  # Hard-stop: no public IP
  associate_public_ip_address = false

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ec2-private" })
}

############################################
# Least-Privilege IAM policies (attach to existing role outside module)
# NOTE: This module CREATES policies; you attach them in root where the role exists.
############################################
resource "aws_iam_policy" "lp_read_params" {
  name        = "${local.name_prefix}-lp-ssm-read"
  description = "Read SSM Parameter Store under /lab/db/*"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ReadLabDbParams"
      Effect = "Allow"
      Action = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
      Resource = [
        "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:parameter/lab/db/*"
      ]
    }]
  })
}
resource "aws_iam_policy" "lp_read_secret" {
  count       = length(var.secret_arn) > 0 ? 1 : 0
  name        = "${local.name_prefix}-lp-secrets-read"
  description = "Read only the specified DB secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "ReadOnlyLabSecret"
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
      Resource = var.secret_arn
    }]
  })
}


resource "aws_iam_policy" "lp_cwlogs" {
  name        = "${local.name_prefix}-lp-cwlogs"
  description = "Write to CloudWatch Logs log group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "WriteLogs"
      Effect = "Allow"
      Action = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"]
      Resource = ["${var.cloudwatch_log_group_arn}:*"]
    }]
  })
}
