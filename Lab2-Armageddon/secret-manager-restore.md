aws secretsmanager restore-secret \
  --secret-id "armageddon/lab2/tokyo/rds" \
  --region ap-northeast-1


aws secretsmanager describe-secret \
  --secret-id "armageddon/lab2/tokyo/rds" \
  --region ap-northeast-1 \
  --query "DeletedDate"

  

  terraform import 'aws_secretsmanager_secret.db[0]' "armageddon/lab2/tokyo/rds"
  
  python malgus_cli.py collect-evidence --secret-id "YOUR_SECRET_ID" --app-log-group "/aws/ec2/yourapp" --waf-log-group "/aws/waf/yourwaf" --out evidence.json

curl -I https://lab2-vpc-alb-45548195.ap-northeast-1.elb.amazonaws.com


  
Outputs:

alb_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:557690581423:loadbalancer/app/lab2-vpc-alb/de58f18572848586"
alb_cert_arn_tokyo = "arn:aws:acm:ap-northeast-1:557690581423:certificate/6fee3da0-ffb5-45e0-8135-38b584352836"
alb_dns_name = "lab2-vpc-alb-45548195.ap-northeast-1.elb.amazonaws.com"
app_fqdn = "www.keyescloudsolutions.com"
azs = tolist([
  "ap-northeast-1a",
  "ap-northeast-1c",
])
cloudfront_distribution_id = "E35WRMYCXLA2KQ"
cloudfront_domain_name = "d1aimpoloveuem.cloudfront.net"
cloudfront_viewer_cert_arn = "arn:aws:acm:us-east-1:557690581423:certificate/ad95409d-aa2f-47a6-af47-b538bca8da62"
cloudfront_waf_arn = "arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/182d7c2d-09f4-4692-a327-4b68c26fc040"
cloudfront_waf_id = "182d7c2d-09f4-4692-a327-4b68c26fc040"
domain_name = "keyescloudsolutions.com"
igw_id = "igw-081dda2084827b548"
origin_header_name = "X-Origin-Verify"
origin_header_value = <sensitive>
private_app_subnet_ids = [
  "subnet-00f33295497e10526",
  "subnet-0292fa7b8d8c15a9d",
]
private_db_subnet_ids = [
  "subnet-0c1e5a10ae84a744a",
  "subnet-0c3f3fe6733313519",
]
public_subnet_ids = [
  "subnet-0b9fe8e3f6ee13889",
  "subnet-07833aa8c2942222c",
]
rds_endpoint = "lab2-vpc-db.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com"
rds_port = 5432
target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:557690581423:targetgroup/lab2-vpc-tg/720ead6fe381112d"
vpc_id = "vpc-0a4e092eed365bcc5"

##########################################################################################

# CloudFront origin-facing prefix list (IPv4)
data "aws_ec2_managed_prefix_list" "cloudfront_origin" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group_rule" "alb_allow_http_from_cloudfront" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id   # <-- your ALB SG resource
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront_origin.id]
  description       = "Allow HTTP from CloudFront origin-facing only"
}

######################################################################################