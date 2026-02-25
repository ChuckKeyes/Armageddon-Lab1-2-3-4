############################################
# Private EC2 App (SSM-managed) + TG attach
############################################

variable "app_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_ami_id" {
  description = "AMI in the same region (Tokyo). Use Amazon Linux 2 or AL2023."
  type        = string
}

# variable "app_port" {
#   description = "App port that ALB forwards to (nginx uses 80)"
#   type        = number
#   default     = 80
# }

# Pick which AZ's private app subnet to place the single instance in
variable "app_az" {
  description = "AZ key for the app instance subnet, must be one of var.azs"
  type        = string
}

# ---------- IAM for SSM ----------
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "app_ssm_role" {
  name               = "${var.project_name}-app-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.tags, { Name = "${var.project_name}-app-ssm-role" })
}

# Core SSM permissions (managed policy)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.project_name}-app-instance-profile"
  role = aws_iam_role.app_ssm_role.name
}

# ---------- EC2 ----------
resource "aws_instance" "app" {
  ami                    = var.app_ami_id
  instance_type          = var.app_instance_type
  subnet_id              = aws_subnet.private_app[var.app_az].id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.app_instance_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    # Amazon Linux 2: install + enable nginx
    yum update -y
    yum install -y nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <html>
      <head><title>Lab2 App</title></head>
      <body>
        <h1>OK - Lab2 private app</h1>
      </body>
    </html>
    HTML

    cat > /usr/share/nginx/html/health <<'HEALTH'
    ok
    HEALTH

    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-ec2"
    Role = "app"
  })
}

# ---------- Attach to ALB Target Group ----------
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app.id
  port             = var.app_port
}