variable "aws_region"  { type = string }
variable "aws_profile" { type = string }

variable "project_name" { type = string }
variable "environment"  { type = string }

variable "tags" {
  type = map(string)
}

variable "vpc_name"  { type = string }
variable "vpc_cidr"  { type = string }

variable "tokyo_vpc_cidr"              { type = string }
variable "tokyo_private_subnet_cidr01" { type = string }
variable "tokyo_private_subnet_cidr02" { type = string }

variable "rds_db_name" { type = string }
variable "rds_username" { type = string }
variable "rds_password" { type = string }

# If your tokyo module still requires these right now:
variable "sao_paulo_vpc_cidr" { type = string }
variable "liberdade_tgw_id"   { type = string }
variable "tokyo_tgw_id"       { type = string }
variable "tokyo_private_route_table_id" { type = string }
