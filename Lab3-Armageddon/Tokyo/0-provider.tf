# Default provider = Tokyo
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Sao Paulo provider (alias)
provider "aws" {
  alias   = "saopaulo"
  region  = "sa-east-1"
  profile = var.aws_profile
}