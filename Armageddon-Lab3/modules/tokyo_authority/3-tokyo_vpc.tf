############################################
# Tokyo VPC foundation (required by TGW + Routes + RDS)
############################################

# resource "aws_vpc" "chewbacca_vpc01" {
#   cidr_block           = var.tokyo_vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "${var.project_name}-tokyo-vpc01"
#   }
# }

# Two PRIVATE subnets (TGW attachments must use subnets)
resource "aws_subnet" "chewbacca_private_subnet01" {
  vpc_id            = local.tokyo_vpc_id
  cidr_block        = var.tokyo_private_subnet01_cidr
  availability_zone = "ap-northeast-1a"
  tags = { Name = "${var.project_name}-tokyo-private-01" }
}

resource "aws_subnet" "chewbacca_private_subnet02" {
  vpc_id            = local.tokyo_vpc_id
  cidr_block        = var.tokyo_private_subnet02_cidr
  availability_zone = "ap-northeast-1c"
  tags = { Name = "${var.project_name}-tokyo-private-02" }
}

# Private route table (your 2-tokyo_routes.tf references this)
resource "aws_route_table" "chewbacca_private_rt01" {
  vpc_id = local.tokyo_vpc_id

  tags   = { Name = "${var.project_name}-tokyo-private-rt01" }
}

resource "aws_route_table_association" "chewbacca_private_assoc01" {
  subnet_id      = aws_subnet.chewbacca_private_subnet01.id
  route_table_id = aws_route_table.chewbacca_private_rt01.id
}

resource "aws_route_table_association" "chewbacca_private_assoc02" {
  subnet_id      = aws_subnet.chewbacca_private_subnet02.id
  route_table_id = aws_route_table.chewbacca_private_rt01.id
}

# One PUBLIC subnet for the app (same VPC)
resource "aws_subnet" "chewbacca_public_subnet01" {
  vpc_id                  = local.tokyo_vpc_id
  cidr_block              = var.tokyo_public_subnet01_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-tokyo-public-01" }
}

resource "aws_subnet" "chewbacca_public_subnet02" {
  vpc_id                  = local.tokyo_vpc_id
  cidr_block              = var.tokyo_public_subnet02_cidr
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-tokyo-public-02" }
}

resource "aws_route_table_association" "chewbacca_public_assoc02" {
  subnet_id      = aws_subnet.chewbacca_public_subnet02.id
  route_table_id = aws_route_table.chewbacca_public_rt01.id
}





resource "aws_internet_gateway" "chewbacca_igw01" {
  vpc_id = local.tokyo_vpc_id

  tags   = { Name = "${var.project_name}-tokyo-igw01" }
}

resource "aws_route_table" "chewbacca_public_rt01" {
  vpc_id = local.tokyo_vpc_id

  tags   = { Name = "${var.project_name}-tokyo-public-rt01" }
}

resource "aws_route" "chewbacca_public_internet" {
  route_table_id         = aws_route_table.chewbacca_public_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.chewbacca_igw01.id
}

resource "aws_route_table_association" "chewbacca_public_assoc01" {
  subnet_id      = aws_subnet.chewbacca_public_subnet01.id
  route_table_id = aws_route_table.chewbacca_public_rt01.id
}

######################################################################

# resource "aws_vpc" "chewbacca_vpc01" {
#   count      = var.existing_tokyo_vpc_id == null ? 1 : 0
#   cidr_block = var.tokyo_vpc_cidr
#   tags       = { Name = "lab3cek-tokyo-vpc" }
# }

# locals {
#   tokyo_vpc_id = var.existing_tokyo_vpc_id != null ? var.existing_tokyo_vpc_id : aws_vpc.chewbacca_vpc01[0].id
# }
