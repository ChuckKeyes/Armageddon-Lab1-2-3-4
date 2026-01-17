# variable "liberdade_vpc_cidr" {}
# variable "liberdade_private_subnet01_cidr" {}
# variable "liberdade_private_subnet02_cidr" {}
# variable "saopaulo_az1" {}
# variable "saopaulo_az2" {}
# variable "tokyo_vpc_cidr" {}

variable "liberdade_private_subnet01_cidr" {
  description = "CIDR for Liberdade private subnet AZ1"
  type        = string
}

variable "liberdade_private_subnet02_cidr" {
  description = "CIDR for Liberdade private subnet AZ2"
  type        = string
}

variable "liberdade_vpc_cidr" {
  description = "CIDR for Liberdade VPC"
  type        = string
}

variable "saopaulo_az1" {
  description = "Primary AZ for São Paulo"
  type        = string
}

variable "saopaulo_az2" {
  description = "Secondary AZ for São Paulo"
  type        = string
}

variable "tokyo_vpc_cidr" {
  type        = string
  description = "Tokyo VPC CIDR"
}
