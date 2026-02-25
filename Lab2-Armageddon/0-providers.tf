terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#########################################
# Default Provider (Tokyo - Lab2 Region)
#########################################

provider "aws" {
  region = var.aws_region
}

#########################################
# us-east-1 Provider Alias
# Required for:
# - CloudFront ACM certificate
# - WAFv2 scope = CLOUDFRONT
#########################################

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}