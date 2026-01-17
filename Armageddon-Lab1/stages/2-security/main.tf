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

module "security" {
  source       = "../../modules/security"
  project_name = var.project_name
  vpc_id       = data.terraform_remote_state.network.outputs.kcs_vpc_id
  db_port      = var.db_port
  my_ip_cidr   = var.my_ip_cidr
}

output "kcs_ec2_sg_id" { value = module.security.ec2_sg_id }
output "kcs_rds_sg_id" { value = module.security.rds_sg_id }
