variable "aws_region" {
  description = "Primary region for Lab2 resources (Tokyo)"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

# Exactly 2 AZs, ex: ["ap-northeast-1a","ap-northeast-1c"]


# Exactly 2 CIDRs each
variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "project_name" { type = string }

variable "azs" {
  description = "Exactly 2 AZs, used as keys for subnet maps"
  type        = list(string)
}

variable "nat_mode" {
  description = "NAT mode: single (cheap) or per_az (HA)"
  type        = string
  default     = "single"
  validation {
    condition     = contains(["single", "per_az"], var.nat_mode)
    error_message = "nat_mode must be 'single' or 'per_az'."
  }
}


variable "app_port" {
  description = "Application port on the EC2 instance (e.g., 80 or 8080)"
  type        = number
  default     = 80
}

