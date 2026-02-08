############################################
# Sao Paulo (Liberdade) - Variables
############################################

variable "liberdade_vpc_cidr" {
  description = "CIDR for Liberdade VPC"
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.liberdade_vpc_cidr))
    error_message = "liberdade_vpc_cidr must be a valid CIDR block (example: 10.20.0.0/16)."
  }
}

variable "liberdade_private_subnet01_cidr" {
  description = "CIDR for Liberdade private subnet AZ1"
  type        = string
  default     = "10.20.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.liberdade_private_subnet01_cidr))
    error_message = "liberdade_private_subnet01_cidr must be a valid CIDR block (example: 10.20.1.0/24)."
  }
}

variable "liberdade_private_subnet02_cidr" {
  description = "CIDR for Liberdade private subnet AZ2"
  type        = string
  default     = "10.20.2.0/24"

  validation {
    condition     = can(cidrnetmask(var.liberdade_private_subnet02_cidr))
    error_message = "liberdade_private_subnet02_cidr must be a valid CIDR block (example: 10.20.2.0/24)."
  }
}

variable "saopaulo_az1" {
  description = "Primary AZ for São Paulo"
  type        = string
  default     = "sa-east-1a"

  validation {
    condition     = length(var.saopaulo_az1) > 0 && can(regex("^sa-east-1[a-z]$", var.saopaulo_az1))
    error_message = "saopaulo_az1 must look like sa-east-1a / sa-east-1b / sa-east-1c."
  }
}

variable "saopaulo_az2" {
  description = "Secondary AZ for São Paulo"
  type        = string
  default     = "sa-east-1b"

  validation {
    condition     = length(var.saopaulo_az2) > 0 && can(regex("^sa-east-1[a-z]$", var.saopaulo_az2))
    error_message = "saopaulo_az2 must look like sa-east-1a / sa-east-1b / sa-east-1c."
  }
}

variable "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR (used for routes from Sao Paulo -> Tokyo over TGW)"
  type        = string
  default     = "10.10.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.tokyo_vpc_cidr))
    error_message = "tokyo_vpc_cidr must be a valid CIDR block (example: 10.10.0.0/16)."
  }
}

############################################
# Optional: TGW peering attachment accepter id
# (so you don't hardcode it in the resource)
############################################
variable "tokyo_to_saopaulo_tgw_attachment_id" {
  description = "TGW peering attachment ID created on the Tokyo side that Sao Paulo must accept (tgw-attach-xxxxxxxx)."
  type        = string
  default     = null

  validation {
    condition = (
      var.tokyo_to_saopaulo_tgw_attachment_id == null
      || can(regex("^tgw-attach-[0-9a-f]+$", var.tokyo_to_saopaulo_tgw_attachment_id))
    )
    error_message = "tokyo_to_saopaulo_tgw_attachment_id must look like tgw-attach-<hex>."
  }
}

variable "tokyo_vpc_id" {
  description = "Tokyo VPC ID"
  type        = string
}

variable "tokyo_rds_sg_id" {
  description = "Tokyo RDS security group id (if referenced cross-region)"
  type        = string
}

# variable "tokyo_private_route_table_ids" {
#   description = "Tokyo private route table ids (if you reference them)"
#   type        = list(string)
#   default     = []
# }

variable "enable_tgw_peering" {
  description = "Whether to create/accept TGW peering between Tokyo and Sao Paulo"
  type        = bool
  default     = false
}

variable "tokyo_peer_attachment_id" {
  type    = string
  default = null
}

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
}

# variable "instance_type" {
#   description = "EC2 instance type for Sao Paulo compute"
#   type        = string
#   default     = "t3.micro"
# }

# variable "tokyo_tgw_id" {
#   description = "Tokyo Transit Gateway ID (from remote state)"
#   type        = string
# }

variable "tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
variable "name_prefix"  { type = string }

############################
# EC2 / Compute
############################

variable "ami_id" {
  description = "AMI ID for Sao Paulo EC2 instances"
  type        = string
}

############################
# Transit Gateway (Tokyo)
############################

variable "enable_tokyo_integration" {
  type    = bool
  default = false
}

variable "tokyo_tgw_id" {
  type    = string
  default = null
}

variable "tokyo_sg_id" {
  type    = string
  default = null
}

variable "saopaulo_tgw_asn" {
  description = "Amazon-side ASN for São Paulo TGW"
  type        = number
  default     = 64521
}
