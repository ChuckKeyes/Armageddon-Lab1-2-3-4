provider "aws" {
  region  = "ap-northeast-1"
  profile = var.aws_profile
}

module "tokyo_med" {
  source      = "./modules/tokyo_medical_center"
  name_prefix = "cek-tokyo-med"

  # Keep DB access tight:
  # - allow ONLY app subnet CIDRs (and later your VPN corridor CIDRs)
  allowed_db_cidrs = ["10.10.110.0/24", "10.10.120.0/24"]

  tags = {
    Lab = "Lab4"
  }
}
