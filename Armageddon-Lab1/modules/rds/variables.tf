variable "project_name" { type = string }

variable "private_subnet_ids" { type = list(string) }
variable "rds_sg_id" { type = string }

variable "db_engine" { type = string }
variable "db_instance_class" { type = string }

variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}
