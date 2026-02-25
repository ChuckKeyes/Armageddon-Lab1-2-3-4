variable "project_name" {
  description = "Project prefix (ex: ceklab1c)"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic triggered by alarms"
  type        = string
}

variable "bedrock_model_id" {
  description = "Bedrock model ID available in this region"
  type        = string
}

variable "app_log_group" {
  description = "CloudWatch log group for application"
  type        = string
}

variable "waf_log_group" {
  description = "CloudWatch log group for WAF (optional)"
  type        = string
  default     = ""
}
