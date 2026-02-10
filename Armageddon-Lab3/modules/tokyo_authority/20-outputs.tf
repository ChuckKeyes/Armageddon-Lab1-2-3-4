
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

output "tokyo_ec2_instance_id" {
  value = aws_instance.tokyo_app_ec2.id
}

output "tokyo_ec2_public_ip" {
  value = aws_instance.tokyo_app_ec2.public_ip
}

output "tokyo_ec2_sg_id" {
  value = aws_security_group.tokyo_ec2_app_sg.id
}

output "tokyo_rds_endpoint" {
  value = aws_db_instance.tokyo_rds.address
}

output "tokyo_rds_port" {
  value = aws_db_instance.tokyo_rds.port
}

output "tokyo_rds_sg_id" {
  value = aws_security_group.tokyo_rds_sg.id
}

output "tokyo_db_secret_arn" {
  value = aws_secretsmanager_secret.tokyo_db_secret.arn
}
