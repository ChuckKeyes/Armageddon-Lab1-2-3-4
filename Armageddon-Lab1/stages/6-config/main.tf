terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.60" }
  }
}

provider "aws" { region = var.aws_region }

data "terraform_remote_state" "rds" {
  backend = "local"
  config = { path = "../04-rds/terraform.tfstate" }
}

module "config" {
  source       = "../../modules/config"
  project_name = var.project_name

  db_endpoint = data.terraform_remote_state.rds.outputs.kcs_rds_endpoint
  db_port     = data.terraform_remote_state.rds.outputs.kcs_rds_port
  db_name     = var.db_name

  db_username = var.db_username
  db_password = var.db_password
}

output "kcs_ssm_db_endpoint_param" { value = module.config.ssm_endpoint_param_name }
output "kcs_ssm_db_port_param" { value = module.config.ssm_port_param_name }
output "kcs_ssm_db_name_param" { value = module.config.ssm_dbname_param_name }
output "kcs_db_secret_arn" { value = module.config.secret_arn }
