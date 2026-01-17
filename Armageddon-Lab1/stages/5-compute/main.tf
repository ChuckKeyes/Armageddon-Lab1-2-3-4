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

data "terraform_remote_state" "iam" {
  backend = "local"
  config = { path = "../03-iam/terraform.tfstate" }
}

module "compute" {
  source       = "../../modules/compute"
  project_name = var.project_name

  ec2_ami_id        = var.ec2_ami_id
  ec2_instance_type = var.ec2_instance_type

  public_subnet_id = data.terraform_remote_state.network.outputs.kcs_public_subnet_ids[0]
  ec2_sg_id        = data.terraform_remote_state.security.outputs.kcs_ec2_sg_id

  instance_profile_name = data.terraform_remote_state.iam.outputs.kcs_instance_profile_name
  user_data_path        = var.user_data_path
}

output "kcs_ec2_instance_id" { value = module.compute.instance_id }
output "kcs_ec2_public_ip" { value = module.compute.public_ip }
output "kcs_ec2_public_dns" { value = module.compute.public_dns }
