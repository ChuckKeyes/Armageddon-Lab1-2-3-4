output "vpce_security_group_id" {
  value = aws_security_group.vpce_sg.id
}

output "s3_gateway_endpoint_id" {
  value = aws_vpc_endpoint.s3_gateway.id
}

output "interface_endpoint_ids" {
  value = { for k, v in aws_vpc_endpoint.interface : k => v.id }
}

output "private_instance_id" {
  value       = try(aws_instance.private[0].id, null)
  description = "ID of private EC2 if created."
}

output "lp_read_params_policy_arn" {
  value = aws_iam_policy.lp_read_params.arn
}

output "lp_read_secret_policy_arn" {
  value = try(aws_iam_policy.lp_read_secret[0].arn, null)
}


output "lp_cwlogs_policy_arn" {
  value = aws_iam_policy.lp_cwlogs.arn
}
