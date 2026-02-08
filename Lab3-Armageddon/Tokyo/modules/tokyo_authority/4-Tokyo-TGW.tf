############################################
# Tokyo TGW (Hub) + VPC Attachment
############################################

resource "aws_ec2_transit_gateway" "tokyo_tgw01" {
  description                     = "${var.project_name}-tokyo-tgw01"
  amazon_side_asn                 = 64512
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.project_name}-tokyo-tgw01"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_vpc_attach01" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw01.id
  vpc_id             = aws_vpc.lab3cek_vpc01.id

  # TGW attachments MUST use subnets (private is correct)
  subnet_ids = [
    aws_subnet.lab3cek_private_subnet01.id,
    aws_subnet.lab3cek_private_subnet02.id
  ]

  tags = {
    Name = "${var.project_name}-tokyo-tgw-vpc-attach01"
  }
}
######################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_saopaulo_peer01" {
  transit_gateway_id      = aws_ec2_transit_gateway.tokyo_tgw01.id
  peer_transit_gateway_id = var.liberdade_tgw_id

  peer_region = "sa-east-1"

  tags = {
    Name = "${var.project_name}-tokyo-to-saopaulo-peer01"
  }
}

# output "tokyo_to_saopaulo_tgw_attachment_id" {
#   value = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo_peer01.id
# }
