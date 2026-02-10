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

output "saopaulo_to_tokyo_attachment_id" {
  value = try(
    aws_ec2_transit_gateway_vpc_attachment.liberdade_to_tokyo[0].id,
    null
  )
}




output "saopaulo_private_route_table_id" {
  value = aws_route_table.liberdade_private_rt01.id
}


output "saopaulo_client_instance_id" {
  value = aws_instance.saopaulo_client_ec2.id
}

output "saopaulo_client_private_ip" {
  value = aws_instance.saopaulo_client_ec2.private_ip
}
