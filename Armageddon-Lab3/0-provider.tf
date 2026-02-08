# Default provider = Tokyo
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "saopaulo"
  region  = "sa-east-1"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "tokyo"
  region  = "ap-northeast-1"
  profile = var.aws_profile
}

