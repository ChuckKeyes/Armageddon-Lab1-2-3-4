############################################
# Variables (Tokyo module inputs)
############################################


############################################
# Routes
############################################

# Create the Tokyo -> São Paulo route ONLY when you have a real TGW ID to route to.
# resource "aws_route" "shinjuku_to_sp_route01" {
#   count = (
#     var.tokyo_tgw_id != null && var.tokyo_tgw_id != "" &&
#     var.sao_paulo_vpc_cidr != null && var.sao_paulo_vpc_cidr != ""
#   ) ? 1 : 0

#   route_table_id         = aws_route_table.chewbacca_private_rt01.id
#   destination_cidr_block = var.sao_paulo_vpc_cidr
#   transit_gateway_id     = var.tokyo_tgw_id
# }

############################################
# Routes (Tokyo)
############################################

# Tokyo private RT -> Sao Paulo VPC via TGW
# resource "aws_route" "tokyo_to_sao_paulo_via_tgw" {
#   count = (
#     var.tokyo_tgw_id != null && var.tokyo_tgw_id != "" &&
#     var.sao_paulo_vpc_cidr != null && var.sao_paulo_vpc_cidr != "" &&
#     var.tokyo_private_route_table_id != null && var.tokyo_private_route_table_id != ""
#   ) ? 1 : 0

#   route_table_id         = var.tokyo_private_route_table_id
#   destination_cidr_block = var.sao_paulo_vpc_cidr
#   transit_gateway_id     = var.tokyo_tgw_id
# }

# ############################################
# # Routes (Tokyo)
# ############################################

# resource "aws_route" "tokyo_private_to_saopaulo_via_tgw" {
#   route_table_id         = "rtb-0989740df1a85b2fe"
#   destination_cidr_block = var.sao_paulo_vpc_cidr
#   transit_gateway_id     = var.tokyo_tgw_id
# }
############################################
# Routes
############################################

locals {
  tokyo_tgw_effective_id = (
    var.tokyo_tgw_id != null && var.tokyo_tgw_id != ""
  ) ? var.tokyo_tgw_id : aws_ec2_transit_gateway.tokyo_tgw01.id
}

resource "aws_route" "shinjuku_to_sp_route01" {
  count                  = var.enable_sp_routes ? 1 : 0
  route_table_id         = aws_route_table.lab3cek_private_rt01.id
  destination_cidr_block = var.sao_paulo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tokyo_tgw01.id
}


############################################
# Routes (Tokyo)
############################################

resource "aws_route" "tokyo_private_to_saopaulo_via_tgw" {
  route_table_id         = "rtb-0989740df1a85b2fe"
  destination_cidr_block = var.sao_paulo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tokyo_tgw01.id
}
