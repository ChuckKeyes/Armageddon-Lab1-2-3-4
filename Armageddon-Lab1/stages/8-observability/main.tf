terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.60" }
  }
}

provider "aws" { region = var.aws_region }

data "terraform_remote_state" "notifications" {
  backend = "local"
  config = { path = "../07-notifications/terraform.tfstate" }
}

module "observability" {
  source         = "../../modules/observability"
  project_name   = var.project_name
  sns_topic_arn  = data.terraform_remote_state.notifications.outputs.kcs_sns_topic_arn
  retention_in_days = var.retention_in_days
}

output "kcs_log_group_name" { value = module.observability.log_group_name }
output "kcs_alarm_name" { value = module.observability.alarm_name }
