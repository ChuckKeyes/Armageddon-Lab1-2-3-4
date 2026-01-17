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

variable "tokyo_private_subnet_cidr01" {
  description = "Tokyo private subnet AZ1"
  type        = string
}

variable "tokyo_private_subnet_cidr02" {
  description = "Tokyo private subnet AZ2"
  type        = string
}

############################################
# TGW / Peering
############################################

variable "liberdade_tgw_id" {
  description = "São Paulo Transit Gateway ID"
  type        = string
}

variable "sao_paulo_vpc_cidr" {
  description = "São Paulo VPC CIDR"
  type        = string
}

############################################
# RDS
############################################

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
