terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.60" }
  }
}

provider "aws" { region = var.aws_region }

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
}

output "kcs_instance_profile_name" { value = module.iam.instance_profile_name }
output "kcs_role_name" { value = module.iam.role_name }
