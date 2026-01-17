############################################
# Tokyo VPC foundation (required by TGW + Routes + RDS)
############################################

resource "aws_vpc" "chewbacca_vpc01" {
  cidr_block           = var.tokyo_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-tokyo-vpc01"
  }
}

# Two PRIVATE subnets (TGW attachments must use subnets)
resource "aws_subnet" "chewbacca_private_subnet01" {
  vpc_id            = aws_vpc.chewbacca_vpc01.id
  cidr_block        = var.tokyo_private_subnet_cidr01
  availability_zone = "ap-northeast-1a"

  tags = { Name = "${var.project_name}-tokyo-private-01" }
}

resource "aws_subnet" "chewbacca_private_subnet02" {
  vpc_id            = aws_vpc.chewbacca_vpc01.id
  cidr_block        = var.tokyo_private_subnet_cidr02
  availability_zone = "ap-northeast-1c"

  tags = { Name = "${var.project_name}-tokyo-private-02" }
}

# Private route table (your 2-tokyo_routes.tf references this)
resource "aws_route_table" "chewbacca_private_rt01" {
  vpc_id = aws_vpc.chewbacca_vpc01.id
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
