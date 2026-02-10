terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "aws" {
#   alias  = "tokyo"
#   region = "ap-northeast-1"
# }

# provider "aws" {
#   alias  = "saopaulo"
#   region = "sa-east-1"
# }





#########################################################################################
############################################
# Tokyo Authority Module
############################################
module "tokyo_authority" {
  source = "./modules/tokyo_authority"

  providers = {
    aws           = aws.tokyo
    aws.us_east_1 = aws.us_east_1
  }

  # Naming / metadata
  name_prefix  = var.name_prefix
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  # VPC (inputs the module expects)
  vpc_name       = var.vpc_name
  vpc_cidr       = var.vpc_cidr
  tokyo_vpc_cidr = var.tokyo_vpc_cidr
  tokyo_public_subnet_cidr01 = var.tokyo_public_subnet_cidr01
  tokyo_public_subnet_cidr02 = var.tokyo_public_subnet_cidr02
  # EC2
  tokyo_ami_id        = var.tokyo_ami_id
  instance_type       = var.instance_type
  # tokyo_app_subnet_id = var.tokyo_app_subnet_id

  # Database
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # RDS subnet group
  # tokyo_private_subnet_ids    = var.tokyo_private_subnet_ids
  tokyo_private_subnet_cidr02 = var.tokyo_private_subnet_cidr02

  # Required by module (for now)
  # tokyo_vpc_id = var.tokyo_vpc_id

 # domain_name = "keyescloudsolutions.com"
  domain_name        = var.domain_name
  origin_domain_name = var.origin_domain_name
  enable_apex        = var.enable_apex

}



############################################
# Root Outputs (optional convenience)
############################################
# output "tokyo_cloudfront_domain_name" {
#   value = module.tokyo_authority.cloudfront_domain_name
# }

# output "tokyo_app_fqdn" {
#   value = module.tokyo_authority.app_fqdn
# }

####################################################################
####################################################################
####################################################################

############################################
# Sao Paulo – Compute Module Call
############################################

module "saopaulo_compute" {
  source = "./modules/saopaulo_compute"



  # REQUIRED: module uses provider = aws.saopaulo
#  provider "aws" {
#   region = "ap-northeast-1"
# }

# provider "aws" {
#   alias  = "saopaulo"
#   region = "sa-east-1"
# }

 providers = {
    aws         = aws.saopaulo
    aws.saopaulo = aws.saopaulo
  }


  project_name = var.project_name
  name_prefix  = "liberdade"

  liberdade_vpc_cidr              = var.saopaulo_vpc_cidr
  liberdade_private_subnet01_cidr = var.saopaulo_private_subnet_cidrs[0]
  liberdade_private_subnet02_cidr = var.saopaulo_private_subnet_cidrs[1]

  saopaulo_az1 = var.saopaulo_az1
  saopaulo_az2 = var.saopaulo_az2
  ami_id       = var.saopaulo_ami_id


  enable_tokyo_integration = true

  # ✅ TGW attach targets Tokyo TGW
 tokyo_tgw_id   = module.tokyo_authority.tokyo_tgw_id
 tokyo_vpc_cidr = module.tokyo_authority.vpc_cidr
 tokyo_vpc_id   = module.tokyo_authority.vpc_id
 tokyo_rds_sg_id = module.tokyo_authority.rds_sg_id




  tags = {
    Project = var.project_name
    Region  = "sa-east-1"
    Role    = "tgw-attach"
  }
}






