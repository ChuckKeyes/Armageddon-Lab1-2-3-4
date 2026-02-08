# output "shinjuku_to_liberdade_peer_attachment_id" {

############################################
# Tokyo Outputs
############################################

output "vpc_id" {
  value = aws_vpc.lab3cek_vpc01.id
}

output "vpc_cidr" {
  value = aws_vpc.lab3cek_vpc01.cidr_block
}

output "private_route_table_ids" {
  value = [
    aws_route_table.lab3cek_private_rt01.id
  ]
}

output "rds_sg_id" {
  value = aws_security_group.lab3cek_rds_sg01.id
}
output "tokyo_tgw_id" {
  value       = aws_ec2_transit_gateway.tokyo_tgw01.id
  description = "Tokyo Transit Gateway ID"
}

output "tokyo_tgw_vpc_attachment_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attach01.id
  description = "Tokyo VPC attachment to TGW"
}

output "tokyo_to_saopaulo_tgw_attachment_id" {
  description = "TGW peering attachment ID (requester side, created in Tokyo)"
  value       = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo_peer01.id
}

# output "vpc_id" {
#   value = aws_vpc.this.id
# }

# output "vpc_cidr" {
#   value = aws_vpc.this.cidr_block
# }

############################################
# Tokyo Outputs (Consumed by Sao Paulo)
############################################

# --- VPC ---
output "tokyo_vpc_id" {
  description = "Tokyo VPC ID"
  value       = aws_vpc.lab3cek_vpc01.id
}

output "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR block"
  value       = aws_vpc.lab3cek_vpc01.cidr_block
}

# --- Routing ---
output "tokyo_private_route_table_ids" {
  description = "Tokyo private route table IDs"
  value = [
    aws_route_table.lab3cek_private_rt01.id
  ]
}

# --- Database access ---
output "tokyo_rds_sg_id" {
  description = "Tokyo RDS security group ID"
  value       = aws_security_group.lab3cek_rds_sg01.id
}

# --- Transit Gateway ---
# output "tokyo_tgw_id" {
#   description = "Tokyo Transit Gateway ID"
#   value       = aws_ec2_transit_gateway.tokyo_tgw01.id
# }

# output "tokyo_tgw_vpc_attachment_id" {
#   description = "Tokyo VPC attachment to Tokyo TGW"
#   value       = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attach01.id
# }

# --- TGW Peering (Requester: Tokyo → Sao Paulo) ---
# output "tokyo_to_saopaulo_tgw_attachment_id" {
#   description = "TGW peering attachment ID (requester side, created in Tokyo)"
#   value       = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo_peer01.id
# }
