terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.60" }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source               = "../modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

output "kcs_vpc_id"             { value = module.network.vpc_id }
output "kcs_public_subnet_ids"  { value = module.network.public_subnet_ids }
output "kcs_private_subnet_ids" { value = module.network.private_subnet_ids }
output "kcs_nat_gateway_id"     { value = module.network.nat_gateway_id }
