##
resource "aws_vpc" "liberdade_vpc01" {
  provider   = aws.saopaulo
  cidr_block = var.liberdade_vpc_cidr
  tags = { Name = "liberdade-vpc01" }
}

resource "aws_subnet" "liberdade_private_subnet01" {
  provider          = aws.saopaulo
  vpc_id            = aws_vpc.liberdade_vpc01.id
  cidr_block        = var.liberdade_private_subnet01_cidr
  availability_zone = var.saopaulo_az1
  tags = { Name = "liberdade-private-subnet01" }
}

resource "aws_subnet" "liberdade_private_subnet02" {
  provider          = aws.saopaulo
  vpc_id            = aws_vpc.liberdade_vpc01.id
  cidr_block        = var.liberdade_private_subnet02_cidr
  availability_zone = var.saopaulo_az2
  tags = { Name = "liberdade-private-subnet02" }
}

resource "aws_route_table" "liberdade_private_rt01" {
  provider = aws.saopaulo
  vpc_id   = aws_vpc.liberdade_vpc01.id
  tags = { Name = "liberdade-private-rt01" }
}

resource "aws_route_table_association" "liberdade_private_rta01" {
  provider       = aws.saopaulo
  subnet_id      = aws_subnet.liberdade_private_subnet01.id
  route_table_id = aws_route_table.liberdade_private_rt01.id
}

resource "aws_route_table_association" "liberdade_private_rta02" {
  provider       = aws.saopaulo
  subnet_id      = aws_subnet.liberdade_private_subnet02.id
  route_table_id = aws_route_table.liberdade_private_rt01.id
}
resource "aws_security_group_rule" "saopaulo_allow_icmp_from_tokyo" {
  count = var.enable_tokyo_integration && var.tokyo_sg_id != null ? 1 : 0

  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.lab3cek_saopaulo_ec2_sg.id
  source_security_group_id = var.tokyo_sg_id
}


resource "aws_security_group" "lab3cek_saopaulo_ec2_sg" {
  provider = aws.saopaulo
  name        = "lab3cek-saopaulo-ec2-sg"
  description = "EC2 SG for Sao Paulo compute"
  vpc_id      = aws_vpc.liberdade_vpc01.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "lab3cek-saopaulo-ec2-sg"
    Project = var.project_name
    Region  = "sa-east-1"
  }
}

# resource "aws_instance" "saopaulo_compute" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id     = var.subnet_ids[0]

#   tags = merge(var.tags, {
#     Name = "${var.name_prefix}-compute"
#   })
# }


# ------------------------------------------------------------
# TGW Attachment: Sao Paulo VPC -> Tokyo TGW
# ------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "liberdade_to_tokyo" {
  count = var.enable_tokyo_integration && var.tokyo_tgw_id != null ? 1 : 0

  transit_gateway_id = var.tokyo_tgw_id
  vpc_id             = aws_vpc.liberdade_vpc01.id
  subnet_ids         = [
    aws_subnet.liberdade_private_subnet01.id,
    aws_subnet.liberdade_private_subnet02.id
  ]

  tags = { Name = "liberdade-to-tokyo" }
}


# ------------------------------------------------------------
# Route private subnets to Tokyo via TGW
# (You have a single private route table used by both subnets)
# ------------------------------------------------------------
resource "aws_route" "liberdade_private_to_tokyo" {
  count = var.enable_tokyo_integration && var.tokyo_tgw_id != null && var.tokyo_vpc_cidr != null ? 1 : 0

  provider = aws.saopaulo

  route_table_id         = aws_route_table.liberdade_private_rt01.id
  destination_cidr_block = var.tokyo_vpc_cidr
  transit_gateway_id     = var.tokyo_tgw_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.liberdade_to_tokyo]
}

