variable "aws_region"  { type = string }
variable "aws_profile" { type = string }

variable "project_name" { type = string }
variable "environment"  { type = string }

variable "tags" {
  type = map(string)
}

variable "vpc_name"  { type = string }
variable "vpc_cidr"  { type = string }

variable "tokyo_vpc_cidr"              { type = string }
variable "tokyo_private_subnet_cidr01" { type = string }
variable "tokyo_private_subnet_cidr02" { type = string }
variable "tokyo_app_subnet_id" {
  type = string
}
variable "tokyo_public_subnet_ids" {
  type = list(string)
  default = [
    "subnet-00a075b915e11941d",
    "subnet-00958f0ba49814af6"
  ]
}


# variable "db_name" { type = string }
# variable "db_username" { type = string }
# variable "db_password" { type = string }

# If your tokyo module still requires these right now:

variable "tokyo_tgw_id"       { type = string }
# variable "tokyo_private_route_table_ids" {
#   type = list(string)
# }

variable "tokyo_tgw_route_table_id" {
  description = "Tokyo TGW route table ID"
  type        = string
}

variable "tokyo_private_route_table_ids" {
  type    = list(string)
  default = ["rtb-0029ea9f5ecc56557"]
}

variable "name_prefix" { type = string }

variable "tokyo_private_subnet_ids" {
  type = list(string)
}

variable "tokyo_public_subnet_cidr01" { type = string }

variable "tokyo_public_subnet_cidr02" {
  type = string
}



variable "tokyo_vpc_id" {
  type = string
  default = null
}




variable "domain_name"  { type = string }     # "keyescloudsolutions.com"
variable "app_subdomain" { type = string }    # "www"

variable "tokyo_ami_id"  { type = string }
variable "instance_type" { type = string }

variable "db_name"     { type = string }
variable "db_username" { type = string }
variable "db_password" { 
          type = string
          sensitive = true 
          }

variable "origin_domain_name" { type = string }
variable "enable_apex" { 
  type = bool 
  default = true 
  }








###########################################################################


variable "liberdade_tgw_id"   { type = string }


variable "saopaulo_vpc_cidr" {
  type = string
}

variable "saopaulo_private_subnet_cidrs" {
  type = list(string)
}

variable "saopaulo_public_subnet_cidrs" {
  type = list(string)
}

variable "saopaulo_ami_id" {
  type = string
}

variable "saopaulo_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "saopaulo_az1" {
  type = string
}

variable "saopaulo_az2" {
  type = string
}

variable "ami_id" {
  description = "AMI ID for Sao Paulo instances (sa-east-1)"
  type        = string
}

# variable "tokyo_private_route_table_ids" {
#   type    = list(string)
#   default = []
# }
