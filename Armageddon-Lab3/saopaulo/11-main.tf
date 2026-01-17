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
