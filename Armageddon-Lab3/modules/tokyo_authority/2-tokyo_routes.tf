############################################
# Variables (Tokyo module inputs)
############################################

# variable "tokyo_private_route_table_id" {
#   type = string
# }

# variable "sao_paulo_vpc_cidr" {
#   type = string
# }

# Use Tokyo-only mode: leave null until corridor exists
# variable "tokyo_tgw_id" {
#   type    = string
#   default = null
# }

# If you are actually using SP TGW ID as the next hop (usually NOT correct),
# keep it optional too. Otherwise remove it entirely.
# variable "liberdade_tgw_id" {
#   type    = string
#   default = null
# }

############################################
# Routes
############################################

# Create the Tokyo -> São Paulo route ONLY when you have a real TGW ID to route to.
resource "aws_route" "shinjuku_to_sp_route01" {
  count = (
    var.tokyo_tgw_id != null && var.tokyo_tgw_id != "" &&
    var.sao_paulo_vpc_cidr != null && var.sao_paulo_vpc_cidr != ""
  ) ? 1 : 0

  route_table_id         = aws_route_table.chewbacca_private_rt01.id
  destination_cidr_block = var.sao_paulo_vpc_cidr
  transit_gateway_id     = var.tokyo_tgw_id
}
