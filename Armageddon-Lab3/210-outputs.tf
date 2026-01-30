output "tokyo_vpc_id" {
  value = module.tokyo.vpc_id
}

output "tokyo_vpc_cidr" {
  value = module.tokyo.vpc_cidr
}

output "tokyo_private_route_table_ids" {
  value = module.tokyo.private_route_table_ids
}

output "tokyo_rds_sg_id" {
  value = module.tokyo.rds_sg_id
}
