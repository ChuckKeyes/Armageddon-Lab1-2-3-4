# output "liberdade_tgw_id" {
#   value = aws_ec2_transit_gateway.liberdade_tgw01.id
# }
output "saopaulo_ec2_sg_id" {
  value = aws_security_group.lab3cek_saopaulo_ec2_sg.id
}

############################################
# São Paulo module outputs
############################################

output "saopaulo_vpc_id" {
  description = "São Paulo VPC ID"
  value       = aws_vpc.liberdade_vpc01.id
}

output "saopaulo_vpc_cidr" {
  description = "São Paulo VPC CIDR"
  value       = aws_vpc.liberdade_vpc01.cidr_block
}

output "saopaulo_private_subnet_ids" {
  description = "São Paulo private subnet IDs"
  value = [
    aws_subnet.liberdade_private_subnet01.id,
    aws_subnet.liberdade_private_subnet02.id
  ]
}

# output "saopaulo_tgw_id" {
#   description = "São Paulo TGW ID"
#   value       = aws_ec2_transit_gateway.saopaulo_tgw.id
# }

output "saopaulo_tgw_vpc_attachment_id" {
  description = "São Paulo VPC attachment to TGW ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.saopaulo_vpc_attach.id
}

output "saopaulo_private_route_table_id" {
  value = aws_route_table.liberdade_private_rt01.id
}
