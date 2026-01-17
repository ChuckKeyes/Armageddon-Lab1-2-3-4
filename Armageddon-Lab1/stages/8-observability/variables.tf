variable "aws_region" { type = string }
variable "project_name" { type = string }

variable "retention_in_days" {
  type    = number
  default = 7
}
