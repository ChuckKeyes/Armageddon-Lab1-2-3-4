resource "aws_security_group" "saopaulo_client_sg" {
  provider = aws.saopaulo

  name        = "${var.name_prefix}-sp-client-sg"
  description = "Sao Paulo client SG"
  vpc_id      = aws_vpc.liberdade_vpc01.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.tokyo_vpc_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.tokyo_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-sp-client-sg" })
}

resource "aws_instance" "saopaulo_client_ec2" {
  provider = aws.saopaulo

  ami                    = var.ami_id
  instance_type          = var.client_instance_type
  subnet_id              = aws_subnet.liberdade_private_subnet01.id
  vpc_security_group_ids = [aws_security_group.saopaulo_client_sg.id]
  key_name               = var.key_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sp-client-ec2"
    Role = "sp-client"
  })
}
