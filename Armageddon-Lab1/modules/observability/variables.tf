variable "project_name" { type = string }
variable "sns_topic_arn" { type = string }

variable "retention_in_days" {
  type    = number
  default = 7
}
