locals {
  igw_name = "${var.vpc_name}-igw"

  public_subnet_names = [
    "${var.vpc_name}-public-az1",
    "${var.vpc_name}-public-az2",
  ]

  private_app_subnet_names = [
    "${var.vpc_name}-app-private-az1",
    "${var.vpc_name}-app-private-az2",
  ]

  private_db_subnet_names = [
    "${var.vpc_name}-db-private-az1",
    "${var.vpc_name}-db-private-az2",
  ]
}