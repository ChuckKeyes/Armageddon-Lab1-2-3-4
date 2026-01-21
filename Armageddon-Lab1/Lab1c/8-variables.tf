variable "aws_region" {
  description = "AWS Region for the ceklab1 fleet to patrol."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for naming. Students should change from 'ceklab1' to their own."
  type        = string
  default     = "ceklab1"
}

variable "vpc_cidr" {
  description = "VPC CIDR (use 10.x.x.x/xx as instructed)."
  type        = string
  default     = "10.0.0.0/16" # TODO: student supplies
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # TODO: student supplies
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"] # TODO: student supplies
}

variable "azs" {
  description = "Availability Zones list (match count with subnets)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # TODO: student supplies
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 app host."
  type        = string
  default     = "ami-07ff62358b87c7116" # TODO
}

variable "ec2_instance_type" {
  description = "EC2 instance size for the app."
  type        = string
  default     = "t3.micro"
}

variable "db_engine" {
  description = "RDS engine."
  type        = string
  default     = "mysql"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_secret_arn" {
  description = "Secrets Manager secret ARN for the DB creds (leave blank if not created yet)."
  type        = string
  default     = ""
}


variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "labdb" # Students can change
}

variable "db_username" {
  description = "DB master username (students should use Secrets Manager in 1B/1C)."
  type        = string
  default     = "admin" # TODO: student supplies
}

variable "db_password" {
  description = "DB master password (DO NOT hardcode in real life; for lab only)."
  type        = string
  sensitive   = true
  default     = "Nicholas111317!" # TODO: student supplies
}

variable "sns_email_endpoint" {
  description = "Email for SNS subscription (PagerDuty simulation)."
  type        = string
  default     = "chuck37080@gmail.com" # TODO: student supplies
}

# variable "private_subnet_ids" {
#   description = "Private subnet IDs for Bonus A (paste from your existing subnets)."
#   type        = list(string)
# }

variable "domain_name" {
  description = "Base domain name (example: keyescloudsolutions.com)"
  type        = string
}

variable "app_subdomain" {
  description = "Subdomain for the ALB app (example: bonus-b or app)"
  type        = string
  default     = "ceklab1c-b"
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for domain_name (example: Z0123456789ABCDEF)"
  type        = string
  default     = ""
}

variable "manage_route53_in_terraform" {
  description = "If true, create the Hosted Zone in this module. If false, use route53_hosted_zone_id."
  type        = bool
  default     = true
}

variable "route53_hosted_zone_id" {
  description = "Existing Route53 Hosted Zone ID (used when manage_route53_in_terraform=false)."
  type        = string
  default     = ""
}




