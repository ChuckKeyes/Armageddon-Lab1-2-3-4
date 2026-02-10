output "tokyo_vpc_id" {
  value = module.tokyo_authority.vpc_id
}

output "tokyo_vpc_cidr" {
  value = module.tokyo_authority.vpc_cidr
}

output "tokyo_private_route_table_ids" {
  value = module.tokyo_authority.private_route_table_ids
}

output "tokyo_rds_sg_id" {
  value = module.tokyo_authority.rds_sg_id
}
##########################################################################

############################################
# São Paulo Outputs
############################################

# output "saopaulo_tgw_id" {
#   description = "São Paulo Transit Gateway ID"
#   value       = module.saopaulo_compute.saopaulo_tgw_id
# }

output "saopaulo_vpc_id" {
  description = "São Paulo VPC ID"
  value       = module.saopaulo_compute.saopaulo_vpc_id
}

output "saopaulo_vpc_cidr" {
  description = "São Paulo VPC CIDR"
  value       = module.saopaulo_compute.saopaulo_vpc_cidr
}

output "saopaulo_private_subnet_ids" {
  description = "São Paulo private subnet IDs"
  value       = module.saopaulo_compute.saopaulo_private_subnet_ids
}

# output "saopaulo_tgw_vpc_attachment_id" {
#   description = "São Paulo VPC → TGW attachment ID"
#   value       = module.saopaulo_compute.saopaulo_tgw_vpc_attachment_id
# }

# output "saopaulo_vpc_id" {
#   value = module.saopaulo_compute.saopaulo_vpc_id
# }

# output "saopaulo_client_private_ip" {
#   value = module.saopaulo_compute.saopaulo_client_private_ip
# }

# output "saopaulo_to_tokyo_attachment_id" {
#   value = module.saopaulo_compute.saopaulo_to_tokyo_attachment_id
# }
