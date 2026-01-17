terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.60" }
  }
}

provider "aws" { region = var.aws_region }

module "notifications" {
  source             = "../../modules/notifications"
  project_name       = var.project_name
  sns_email_endpoint = var.sns_email_endpoint
}

output "kcs_sns_topic_arn" { value = module.notifications.sns_topic_arn }
