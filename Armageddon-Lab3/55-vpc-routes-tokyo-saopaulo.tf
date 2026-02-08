############################################
# VPC Route Table Routes (Tokyo <-> São Paulo)
############################################

# Tokyo: send São Paulo CIDR to Tokyo TGW
# resource "aws_route" "tokyo_private_to_saopaulo" {
#   provider = aws.tokyo

#   route_table_id         = var.tokyo_private_route_table_id
#   destination_cidr_block = module.saopaulo_compute.saopaulo_vpc_cidr
#   transit_gateway_id     = "tgw-04a758504cdbb5c89"
# }


# São Paulo: send Tokyo CIDR to São Paulo TGW
# resource "aws_route" "saopaulo_private_to_tokyo" {
#   provider = aws.saopaulo

#   route_table_id         = module.saopaulo_compute.saopaulo_private_route_table_id
#   destination_cidr_block = var.tokyo_vpc_cidr
#   transit_gateway_id     = module.saopaulo_compute.saopaulo_tgw_id
# }

# resource "aws_route" "tokyo_private_to_saopaulo" {
#   provider = aws.tokyo
#   for_each = toset(module.tokyo.tokyo_private_route_table_ids)

#   route_table_id         = each.value
#   destination_cidr_block = module.saopaulo_compute.saopaulo_vpc_cidr
#   transit_gateway_id     = "tgw-04a758504cdbb5c89"
# }
