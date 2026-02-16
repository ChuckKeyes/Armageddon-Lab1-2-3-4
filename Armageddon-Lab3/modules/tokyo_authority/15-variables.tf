############################################
# Core Project Settings
############################################

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, lab)"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

############################################
# VPC
############################################

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "Primary VPC CIDR"
  type        = string
}

variable "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR"
  type        = string
}







variable "name_prefix" {
  type        = string
  description = "Naming prefix (ex: lab3cek)"
}



# Networking inputs (use your existing outputs/locals if you already have VPC/subnets in-module)
variable "tokyo_vpc_id" {
  type        = string
  description = "Tokyo VPC ID"
  default     = null
}

variable "tokyo_app_subnet_id" {
  type        = string
  description = "Subnet ID for the app EC2 (public for simple / private if using ALB)"
  default     = null
}

# EC2 inputs
variable "tokyo_ami_id" {
  type        = string
  description = "AMI ID in ap-northeast-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "associate_public_ip" {
  type        = bool
  description = "Give the app instance a public IP (true for public subnet simple build)"
  default     = true
}

# HTTP ingress (start open, tighten later to ALB SG only)
variable "app_http_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to hit app over HTTP"
  default     = ["0.0.0.0/0"]
}

# Optional SSH (break-glass)
variable "enable_ssh" {
  type        = bool
  description = "Enable SSH ingress (break-glass)"
  default     = false
}

variable "ssh_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed SSH (only used if enable_ssh=true)"
  default     = []
}



variable "kms_key_arn" {
  type        = string
  description = "Optional CMK ARN if secret uses a customer-managed KMS key"
  default     = null
}


############################################
# TGW / Peering
############################################

variable "tokyo_tgw_id" {
  description = "Tokyo TGW ID (optional: if null, use TGW created in this module)"
  type        = string
  default     = null
}



############################################
# RDS
############################################

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}





# RDS sizing / options
variable "rds_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "rds_engine_version" {
  type        = string
  description = "MySQL engine version"
  default     = "8.0"
}

variable "rds_allocated_storage" {
  type        = number
  description = "Initial storage in GB"
  default     = 20
}

variable "rds_max_allocated_storage" {
  type        = number
  description = "Max autoscaling storage in GB"
  default     = 100
}

variable "rds_multi_az" {
  type        = bool
  description = "Enable Multi-AZ"
  default     = false
}

variable "rds_deletion_protection" {
  type        = bool
  description = "Prevent accidental deletion"
  default     = false
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot on destroy"
  default     = true
}

#######################################################

#     DNS     Route 53      Cloudfront      ACM  health_check

#########################################################

variable "domain_name" {
  type        = string
  description = "Base domain, e.g. keyescloudsolutions.com"
}

variable "origin_domain_name" {
  type        = string
  description = "Origin domain name for CloudFront (ALB DNS recommended, or EC2 public DNS)"
}

variable "enable_apex" {
  type        = bool
  description = "If true, include apex domain as SAN + CloudFront alias"
  default     = true
}

variable "app_port" {
  type        = number
  description = "App port on EC2"
  default     = 80
}

variable "health_check_path" {
  type        = string
  description = "ALB health check path"
  default     = "/"
}

# variable "tokyo_public_subnet_cidr01" { type = string }
# variable "tokyo_public_subnet_cidr02" { type = string }
# variable "tokyo_private_subnet_cidr01" {
#   description = "Tokyo private subnet AZ1"
#   type        = string
#   default     = null
# }
# variable "tokyo_private_subnet_cidr02" {
#   description = "Tokyo private subnet AZ2"
#   type        = string
# }


variable "tokyo_private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the DB subnet group"
  default     = []
}


variable "tokyo_private_subnet01_cidr" { type = string }
variable "tokyo_private_subnet02_cidr" { type = string }
variable "tokyo_public_subnet01_cidr"  { type = string }
variable "tokyo_public_subnet02_cidr"  { type = string }



variable "existing_tokyo_vpc_id" {
  type        = string
  default     = null
  description = "If set, Tokyo module will use this existing VPC instead of creating a new one"
}

variable "existing_tokyo_subnet_ids" {
  type    = list(string)
  default = []
}

#####################################################################

# variable "tokyo_db_secret_name" {
#   description = "Name of the existing Tokyo RDS secret in Secrets Manager"
#   type        = string
# }
