variable "name_prefix" {
  type        = string
  description = "Prefix for resource names, e.g. cek-tokyo"
}

variable "aws_region" {
  type        = string
  description = "Tokyo region, typically ap-northeast-1"
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for Tokyo VPC"
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Two public subnet CIDRs"
  default     = ["10.10.10.0/24", "10.10.20.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Two private subnet CIDRs (DB + app)"
  default     = ["10.10.110.0/24", "10.10.120.0/24"]
}

variable "allowed_db_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the DB (e.g., GCP corridor CIDR or app subnet CIDR). Keep tight."
  default     = []
}

# ---- RDS settings ----
variable "db_engine" {
  type        = string
  description = "postgres or mysql"
  default     = "postgres"
}

variable "db_engine_version" {
  type        = string
  description = "Engine version"
  default     = "16.3"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  default     = 20
}

variable "db_name" {
  type        = string
  default     = "medical"
}

variable "db_username" {
  type        = string
  default     = "medadmin"
}

variable "db_port" {
  type        = number
  default     = 5432
}

variable "db_backup_retention_days" {
  type        = number
  default     = 7
}

variable "db_multi_az" {
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
}
