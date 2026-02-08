# output "shinjuku_to_liberdade_peer_attachment_id" {
#   value = module.tgw_tokyo.shinjuku_to_liberdade_peer_attachment_id
# }

# output "vpc_id" {
#   value = aws_vpc.chewbacca_vpc01.id
# }

# output "private_subnet_ids" {
#   value = [
#     aws_subnet.chewbacca_private_subnet01.id,
#     aws_subnet.chewbacca_private_subnet02.id
#   ]
# }

# output "private_route_table_id" {
#   value = aws_route_table.chewbacca_private_rt01.id
# }

# output "vpc_id" {
#   value = aws_vpc.<tokyo_vpc_resource_name>.id
# }

# output "vpc_cidr" {
#   value = aws_vpc.<tokyo_vpc_resource_name>.cidr_block
# }

# output "private_route_table_ids" {
#   value = [aws_route_table.<tokyo_private_rt_name>.id]
#   # or multiple RTs if you have one per AZ
# }

# output "rds_sg_id" {
#   value = aws_security_group.<tokyo_rds_sg_name>.id
# }

############################################
# Tokyo Outputs
############################################

output "vpc_id" {
  value = aws_vpc.chewbacca_vpc01.id
}

output "vpc_cidr" {
  value = aws_vpc.chewbacca_vpc01.cidr_block
}

output "private_route_table_ids" {
  value = [
    aws_route_table.chewbacca_private_rt01.id
  ]
}

output "rds_sg_id" {
  value = aws_security_group.chewbacca_rds_sg01.id
}

output "tokyo_tgw_id" {
  description = "Tokyo Transit Gateway ID"
  value       = aws_ec2_transit_gateway.tokyo_tgw.id
}

# output "tokyo_tgw_id" {
#   description = "Tokyo Transit Gateway ID"
#   value       = aws_ec2_transit_gateway.tokyo_tgw_id.id
# }
# output "tokyo_vpc_id" {
#   value = aws_vpc."vpc-07731da43ab3eb9a1".id
# }

# output "tokyo_rds_sg_id" {
#   value = aws_security_group."sg-04009ac9e7051b5b5".id
# }

# output "tokyo_private_route_table_ids" {
#   value = [aws_route_table."rtb-0029ea9f5ecc56557".id] # or whatever you actually have
# }

####################################################################################

# output "saopaulo_private_route_table_id" {
#   value = aws_route_table.liberdade_private_rt01.id
# }

