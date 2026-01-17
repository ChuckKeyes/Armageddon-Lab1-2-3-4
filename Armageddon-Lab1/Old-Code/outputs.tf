# Explanation: Outputs are your mission report—what got built and where to find it.
output "kcs_vpc_id" {
  value = aws_vpc.kcs_vpc01.id
}

output "kcs_public_subnet_ids" {
  value = aws_subnet.kcs_public_subnets[*].id
}

output "kcs_private_subnet_ids" {
  value = aws_subnet.kcs_private_subnets[*].id
}

output "kcs_ec2_instance_id" {
  value = aws_instance.kcs_ec201.id
}

output "kcs_rds_endpoint" {
  value = aws_db_instance.kcs_rds01.address
}

output "kcs_sns_topic_arn" {
  value = aws_sns_topic.kcs_sns_topic01.arn
}

output "kcs_log_group_name" {
  value = aws_cloudwatch_log_group.kcs_log_group01.name
}

# EC2 Public IP (SSH / HTTP access)
output "kcs_ec2_public_ip" {
  description = "Public IP address of the KCS EC2 instance"
  value       = aws_instance.kcs_ec201.public_ip
}

# EC2 Public DNS (browser / curl access)
output "kcs_ec2_public_dns" {
  description = "Public DNS name of the KCS EC2 instance"
  value       = aws_instance.kcs_ec201.public_dns
}

# RDS Port (needed for DB clients)
output "kcs_rds_port" {
  description = "Port number for the KCS RDS instance"
  value       = aws_db_instance.kcs_rds01.port
}

# RDS Identifier (useful in console & logs)
output "kcs_rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.kcs_rds01.id
}
