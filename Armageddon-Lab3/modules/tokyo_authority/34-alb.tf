############################################
# 34-alb.tf
# ALB -> Target Group -> Listener -> EC2 attachment
############################################

# ALB Security Group: allow inbound 80/443 from internet
resource "aws_security_group" "tokyo_alb_sg" {
  name        = "${var.name_prefix}-tokyo-alb-sg"
  description = "ALB SG: allow HTTP/HTTPS from internet"
  vpc_id      = local.tokyo_vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet (optional )"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-alb-sg"
  })
}

# IMPORTANT: EC2 SG should allow inbound from ALB SG (not 0.0.0.0/0)
# If your EC2 SG currently allows 80 from anywhere, tighten it to this:
# ingress { from_port=80 to_port=80 protocol="tcp" security_groups=[aws_security_group.tokyo_alb_sg.id] }

resource "aws_lb" "tokyo_alb" {
  name               = "${var.name_prefix}-tokyo-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.tokyo_alb_sg.id]

  # ALB needs at least two subnets (two AZs). We will use your TWO public subnets.
  subnets = local.tokyo_public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-alb"
  })
}

resource "aws_lb_target_group" "tokyo_app_tg" {
  name        = "${var.name_prefix}-tokyo-app-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = local.tokyo_vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200-399"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tokyo-app-tg"
  })
}

# Listener: HTTP :80 -> forward to target group
resource "aws_lb_listener" "tokyo_http" {
  load_balancer_arn = aws_lb.tokyo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tokyo_app_tg.arn
  }
}

# Attach EC2 to target group
resource "aws_lb_target_group_attachment" "tokyo_app_ec2_attach" {
  target_group_arn = aws_lb_target_group.tokyo_app_tg.arn
  target_id        = aws_instance.tokyo_app_ec2.id
  port             = var.app_port
}

############################################
# Outputs (used by CloudFront origin)
############################################
output "alb_dns_name" {
  value = aws_lb.tokyo_alb.dns_name
}

output "alb_arn" {
  value = aws_lb.tokyo_alb.arn
}
