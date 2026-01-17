output "ssm_endpoint_param_name" { value = aws_ssm_parameter.db_endpoint.name }
output "ssm_port_param_name" { value = aws_ssm_parameter.db_port.name }
output "ssm_dbname_param_name" { value = aws_ssm_parameter.db_name.name }
output "secret_arn" { value = aws_secretsmanager_secret.db.arn }
