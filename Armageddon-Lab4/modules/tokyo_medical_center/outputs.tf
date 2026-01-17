output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "db_endpoint" {
  value = aws_db_instance.db.address
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "db_name" {
  value = aws_db_instance.db.db_name
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}
