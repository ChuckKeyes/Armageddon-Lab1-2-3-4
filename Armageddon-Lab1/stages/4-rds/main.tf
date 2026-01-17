terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.60" }
  }
}

provider "aws" { region = var.aws_region }

data "terraform_remote_state" "network" {
  backend = "local"
  config = { path = "../01-network/terraform.tfstate" }
}

data "terraform_remote_state" "security" {
  backend = "local"
  config = { path = "../02-security/terraform.tfstate" }
}

module "rds" {
  source             = "../../modules/rds"
  project_name       = var.project_name
  private_subnet_ids = data.terraform_remote_state.network.outputs.kcs_private_subnet_ids
  rds_sg_id          = data.terraform_remote_state.security.outputs.kcs_rds_sg_id

  db_engine         = var.db_engine
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

output "kcs_rds_endpoint" { value = module.rds.db_endpoint }
output "kcs_rds_port" { value = module.rds.db_port }
output "kcs_rds_identifier" { value = module.rds.db_identifier }
