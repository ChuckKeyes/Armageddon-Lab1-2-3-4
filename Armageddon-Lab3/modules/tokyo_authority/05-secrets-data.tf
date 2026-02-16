variable "tokyo_db_secret_name" {
  description = "Name of the existing Secrets Manager secret for Tokyo DB creds"
  type        = string
}

# data "aws_secretsmanager_secret" "tokyo_db_secret" {
#   provider = aws
#   name = var.tokyo_db_secret_name
# }
