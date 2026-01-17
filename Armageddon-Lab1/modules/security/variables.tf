variable "project_name" { type = string }
variable "vpc_id" { type = string }

variable "db_port" {
  type    = number
  default = 3306
}

# Set to "" if you don't want SSH opened.
variable "my_ip_cidr" {
  type    = string
  default = ""
}
