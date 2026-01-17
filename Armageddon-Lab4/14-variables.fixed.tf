variable "gcp_project_id" {
  description = "GCP project ID to deploy into."
  type        = string
}

variable "gcp_region" {
  description = "GCP region for regional resources."
  type        = string
  default     = "us-central1"
}

# Students provide these (network ranges)
variable "nihonmachi_vpc_cidr" {
  description = "CIDR range for the Nihonmachi VPC."
  type        = string
  default     = "10.100.0.0/16"
}

variable "nihonmachi_subnet_cidr" {
  description = "CIDR range for the Nihonmachi subnet."
  type        = string
  default     = "10.100.1.0/24"
}

# Who is allowed to access the private URL (e.g., VPN/TGW subnets)
variable "allowed_vpn_cidrs" {
  description = "List of CIDR blocks allowed to reach protected endpoints."
  type        = list(string)
  default     = ["10.100.0.0/16"] # students: add AWS Tokyo VPC CIDR, corp VPN CIDR, etc.
}

# Tokyo RDS endpoint (private, reachable over VPN)
variable "tokyo_rds_host" {
  description = "Tokyo RDS endpoint hostname (private DNS or IP)."
  type        = string
  default     = "tokyo-rds-endpoint.example"
}

variable "tokyo_rds_port" {
  description = "Tokyo RDS port."
  type        = number
  default     = 3306
}

# DB user is OK to store as plain var; password should not be in TF state (use Secret Manager)
variable "tokyo_rds_user" {
  description = "Database username used by the application."
  type        = string
  default     = "appuser"
}

# Secret name holding DB password (created outside TF or by TF—your choice)
variable "db_password_secret_name" {
  description = "Secret Manager secret name that stores the DB password."
  type        = string
  default     = "nihonmachi-tokyo-rds-password"
}

variable "aws_profile" {
  description = "AWS CLI profile name to use"
  type        = string
}
