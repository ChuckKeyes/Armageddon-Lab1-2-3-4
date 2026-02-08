resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = local.igw_name
  })
}

# resource "aws_security_group_rule" "saopaulo_allow_icmp_from_tokyo" {
#   type              = "ingress"
#   protocol          = "icmp"
#   from_port         = -1
#   to_port           = -1
#   cidr_blocks       = [var.tokyo_vpc_cidr]

#   security_group_id = aws_security_group.lab3cek_saopaulo_ec2_sg.id
# }
