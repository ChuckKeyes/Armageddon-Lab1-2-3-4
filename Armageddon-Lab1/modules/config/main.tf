locals { name_prefix = var.project_name }

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/lab/db/endpoint"
  type  = "String"
  value = var.db_endpoint

  tags = { Name = "${local.name_prefix}-param-db-endpoint" }
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/lab/db/port"
  type  = "String"
  value = tostring(var.db_port)

  tags = { Name = "${local.name_prefix}-param-db-port" }
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/lab/db/name"
  type  = "String"
  value = var.db_name

  tags = { Name = "${local.name_prefix}-param-db-name" }
}

resource "aws_secretsmanager_secret" "db" {
  name = "${local.name_prefix}/rds/mysql"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = var.db_endpoint
    port     = var.db_port
    dbname   = var.db_name
  })
}
