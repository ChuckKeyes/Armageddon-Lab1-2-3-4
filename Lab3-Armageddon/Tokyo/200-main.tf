terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}


module "tokyo" {
  source = "./modules/tokyo_authority"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
   tokyo_vpc_cidr = var.tokyo_vpc_cidr
  
  tokyo_private_subnet_cidr01 = var.tokyo_private_subnet_cidr01
  tokyo_private_subnet_cidr02 = var.tokyo_private_subnet_cidr02

  rds_db_name  = var.rds_db_name
  rds_username = var.rds_username
  rds_password = var.rds_password

  # these are only here because your module currently requires them
  # tokyo_tgw_id                 = var.tokyo_tgw_id
  # tokyo_private_route_table_id = var.tokyo_private_route_table_id

  sao_paulo_vpc_cidr = var.sao_paulo_vpc_cidr
  liberdade_tgw_id   = var.liberdade_tgw_id
  saopaulo_tgw_id    = var.saopaulo_tgw_id
}

