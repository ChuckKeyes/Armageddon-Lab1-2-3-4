############################################
# São Paulo Transit Gateway (sa-east-1)
############################################

resource "aws_ec2_transit_gateway" "saopaulo_tgw" {
  provider = aws.saopaulo

  description                     = "${var.project_name}-saopaulo-tgw"
  amazon_side_asn                 = var.saopaulo_tgw_asn
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = merge(var.tags, {
    Name   = "${var.project_name}-saopaulo-tgw"
    Region = "sa-east-1"
    Role   = "tgw"
  })
}

output "saopaulo_tgw_id" {
  value = aws_ec2_transit_gateway.saopaulo_tgw.id
}

############################################
# Attach Liberdade VPC to São Paulo TGW
############################################
resource "aws_ec2_transit_gateway_vpc_attachment" "saopaulo_vpc_attach" {
  provider = aws.saopaulo

  transit_gateway_id = aws_ec2_transit_gateway.saopaulo_tgw.id
  vpc_id             = aws_vpc.liberdade_vpc01.id

  subnet_ids = [
    aws_subnet.liberdade_private_subnet01.id,
    aws_subnet.liberdade_private_subnet02.id
  ]

  tags = merge(var.tags, {
    Name   = "${var.project_name}-saopaulo-vpc-attach"
    Region = "sa-east-1"
  })
}
