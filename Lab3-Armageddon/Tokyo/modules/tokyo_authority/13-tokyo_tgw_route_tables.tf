############################################
# Tokyo TGW Route Table(s) + assoc/prop
############################################

# Dedicated TGW route table (instead of relying on the TGW default RT)
resource "aws_ec2_transit_gateway_route_table" "tokyo_core_rt01" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw01.id

  tags = {
    Name = "${var.project_name}-tokyo-tgw-rt-core01"
  }
}

############################################
# Associations (which attachment uses this RT)
############################################

# Associate Tokyo VPC attachment to the Tokyo TGW route table
resource "aws_ec2_transit_gateway_route_table_association" "tokyo_vpc_assoc_core01" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attach01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_core_rt01.id
}

# Associate Tokyo <-> Sao Paulo peering attachment to the Tokyo TGW route table
# NOTE: If the peering is still "pendingAcceptance", this may fail on the first apply.
# In that case: accept the peering on Sao Paulo side, then run apply again.
resource "aws_ec2_transit_gateway_route_table_association" "tokyo_peer_assoc_core01" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo_peer01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_core_rt01.id
}

############################################
# Propagation (what routes get learned into this RT)
############################################

# Propagate Tokyo VPC routes into the TGW RT (so peer side can reach Tokyo VPC CIDR)
resource "aws_ec2_transit_gateway_route_table_propagation" "tokyo_vpc_prop_core01" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attach01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_core_rt01.id
}

# Propagate Peering routes into the TGW RT (optional but usually desired)
resource "aws_ec2_transit_gateway_route_table_propagation" "tokyo_peer_prop_core01" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo_peer01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_core_rt01.id
}

######################################################################################################

############################################
# TGW Routes (CIDR -> attachment)
############################################

# Route: Sao Paulo VPC CIDR goes to the peering attachment
resource "aws_ec2_transit_gateway_route" "tokyo_to_saopaulo_vpc_route01" {
  destination_cidr_block         = var.sao_paulo_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo_peer01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_core_rt01.id
}

# Route: Tokyo VPC CIDR goes to the Tokyo VPC attachment (so Sao Paulo -> Tokyo works)
resource "aws_ec2_transit_gateway_route" "tokyo_vpc_local_route01" {
  destination_cidr_block         = var.tokyo_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attach01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_core_rt01.id
}
