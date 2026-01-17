variable "aws_region" { type = string }
variable "project_name" { type = string }

variable "db_port" {
  type    = number
  default = 3306
}

variable "my_ip_cidr" {
  type    = string
  default = ""
}
