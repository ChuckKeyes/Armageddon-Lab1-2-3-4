############################################
# locals.tf
############################################

locals {
  # Base name used across tags + resource names
  name = var.vpc_name

  # Internet Gateway name
  igw_name = "${local.name}-igw"

  # (Used later by your ALB file)
  alb_name = "${local.name}-alb"
}
