######################
############################################
# 30-ec2-app.tf (Tokyo)
# EC2 + IAM role/profile + SG + user_data
############################################

############################
# IAM role for EC2 (SSM + Secrets)
############################

data "aws_iam_policy_document" "tokyo_ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tokyo_ec2_role" {
  name               = "${var.name_prefix}-tokyo-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.tokyo_ec2_assume_role.json
}

# SSM Session Manager core permissions
resource "aws_iam_role_policy_attachment" "tokyo_ec2_ssm_core" {
  role       = aws_iam_role.tokyo_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Allow EC2 to read the DB secret (and decrypt if needed)
data "aws_iam_policy_document" "tokyo_ec2_secrets_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [data.aws_secretsmanager_secret.tokyo_db_secret.arn]

  }

  # Optional: If your secret is encrypted with a CMK, allow decrypt.
  # If you're using the default AWS-managed key for Secrets Manager, this often isn't needed.
  dynamic "statement" {
    for_each = var.kms_key_arn != null && var.kms_key_arn != "" ? [1] : []
    content {
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = [var.kms_key_arn]
    }
  }
}

resource "aws_iam_policy" "tokyo_ec2_secrets_policy" {
  name   = "${var.name_prefix}-tokyo-ec2-read-db-secret"
  policy = data.aws_iam_policy_document.tokyo_ec2_secrets_policy.json
}

resource "aws_iam_role_policy_attachment" "tokyo_ec2_secrets_attach" {
  role       = aws_iam_role.tokyo_ec2_role.name
  policy_arn = aws_iam_policy.tokyo_ec2_secrets_policy.arn
}

resource "aws_iam_instance_profile" "tokyo_ec2_instance_profile" {
  name = "${var.name_prefix}-tokyo-ec2-profile"
  role = aws_iam_role.tokyo_ec2_role.name
}

############################
# Security group for EC2 app
############################

resource "aws_security_group" "tokyo_ec2_app_sg" {
  name        = "${var.name_prefix}-tokyo-ec2-app-sg"
  description = "EC2 app SG (HTTP in, all egress)"
  vpc_id      = local.tokyo_vpc_id

  # Allow HTTP (tighten later to ALB SG once ALB exists)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.app_http_ingress_cidrs
  }

  # Optional SSH (break-glass only). Keep disabled by default.
  dynamic "ingress" {
    for_each = var.enable_ssh ? [1] : []
    content {
      description = "SSH (break-glass)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_ingress_cidrs
    }
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-ec2-app-sg"
  })
}

############################
# EC2 instance (Tokyo app host)
############################

resource "aws_instance" "tokyo_app_ec2" {
  ami                    = var.tokyo_ami_id
  instance_type          = var.instance_type
  subnet_id              = local.tokyo_app_subnet_id
  vpc_security_group_ids = [aws_security_group.tokyo_ec2_app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.tokyo_ec2_instance_profile.name

  associate_public_ip_address = var.associate_public_ip

  # Uses your existing startup script
  user_data = file("${path.module}/data.sh")

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-app-ec2"
    Role = "app"
  })
}
