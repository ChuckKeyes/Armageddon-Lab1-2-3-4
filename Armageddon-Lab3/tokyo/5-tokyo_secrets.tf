resource "aws_secretsmanager_secret" "tokyo_db_secret" {
  name = "${var.project_name}/tokyo/rds-v2"
}

resource "aws_secretsmanager_secret_version" "tokyo_db_secret_value" {
  secret_id = aws_secretsmanager_secret.tokyo_db_secret.id

  secret_string = jsonencode(
    {
      username = var.rds_username
      password = var.rds_password
      dbname   = var.rds_db_name
    }
  )
}
#  {
# #  lifecycle {
# #     prevent_destroy = true
# #   }

#   tags = var.tags
# }

