0-providers.tf

1-variables.tf

10-network.tf

20-security_groups.tf

30-alb.tf

40-ec2_private.tf

50-rds.tf

60-route53_zone.tf

70-acm_use1_cloudfront.tf

80-waf_cloudfront.tf

90-cloudfront.tf

95-origin_cloaking_rules.tf

99-route53_to_cloudfront.tf

outputs.tf

###############################################################################


Step 1 — Providers (Tokyo + us-east-1)

Goal: CloudFront cert must be in us-east-1.

0-providers.tf

provider "aws" { region = "ap-northeast-1" } (Tokyo)

provider "aws" { alias = "use1" region = "us-east-1" }

Also add:

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
##################################################################################

Step 2 — VPC and subnets

Goal: ALB in public subnets, EC2 + RDS in private subnets, NAT for private outbound.

10-network.tf
Create:

aws_vpc.main

aws_internet_gateway.igw

2 public subnets (different AZs)

2 private app subnets (different AZs)

2 private db subnets (different AZs) (or reuse private, but better separate)

aws_eip.nat

aws_nat_gateway.nat in a public subnet

Public route table: default route to IGW

Private route tables: default route to NAT

#############################################################################

Step 3 — Security Groups (the “rules of the game”)

20-security_groups.tf

Create these SGs:

A) ALB SG (locked to CloudFront)

aws_security_group.alb_sg

Ingress 443 only from CloudFront origin-facing prefix list

Egress: allow all (or at least to EC2)

You’ll need the AWS-managed prefix list:

data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" { name = "com.amazonaws.global.cloudfront.origin-facing" }
(That exact name is what you want; it’s the standard one AWS publishes.)

B) EC2 SG (only ALB can reach it)

aws_security_group.app_sg

Ingress: app port (80 or 8080) from alb_sg

Egress: allow all (or at least to RDS + SSM endpoints)

C) RDS SG (only EC2 can reach it)

aws_security_group.rds_sg

Ingress: 5432 (or your engine port) from app_sg

Egress: allow all (or default)

############################################################################

Step 4 — ALB + Target Group + Listeners

30-alb.tf

Canonical labels (so your overlay never breaks):

aws_lb.alb

aws_lb_target_group.tg

aws_lb_listener.http (optional redirect)

aws_lb_listener.https

ALB must be in the public subnets.

Listener strategy:

Port 80: redirect → 443 (recommended)

Port 443: forwards to TG (but we will add listener RULES for origin header later)

ALB HTTPS needs a regional ACM cert in Tokyo (not us-east-1).
So either:

Create Tokyo ACM cert too, OR

Temporarily use HTTP only (not recommended for your “locked ALB” lab rule)

Best practice: create a Tokyo ACM cert for the ALB listener, and a us-east-1 cert for CloudFront viewer cert.

###########################################################################

Step 5 — Private EC2 (SSM-managed)

40-ec2_private.tf

Create:

aws_instance.app in private app subnet

no public IP

IAM role/profile with SSM

user_data to run a simple web server (nginx) and a health endpoint (e.g., /health)

Attach to TG:

aws_lb_target_group_attachment.app

######################################################################

Step 6 — RDS in private DB subnets

50-rds.tf

Create:

aws_db_subnet_group.db_subnets (private db subnets)

aws_db_instance.db (private, no public access)

use Secrets Manager or variables for creds.................................  vpc_security_group_ids = [aws_security_group.rds_sg.id]

####################################################################

Step 7 — Route53 zone lookup + locals

70-route53_zone.tf

Use:

data "aws_route53_zone" "primary" { name = "${var.domain_name}." private_zone = false }
Locals:

local.zone_id

local.app_fqdn = "${var.app_subdomain}.${var.domain_name}"

###################################################################

Step 8 — ACM Certificate for CloudFront (us-east-1)

75-acm_use1_cloudfront.tf

Create in us-east-1:

aws_acm_certificate.cf_cert with:

domain_name = var.domain_name

SAN = local.app_fqdn

provider = aws.use1

Create DNS validation records in Route53 (zone_id = local.zone_id)

aws_acm_certificate_validation.cf_cert_validation (provider = aws.use1)

This cert is used only by CloudFront viewer certificate.

#######################################################################

Step 9 — WAFv2 for CloudFront

80-waf_cloudfront.tf

Create:

aws_wafv2_web_acl.cf_waf

scope = "CLOUDFRONT"

default allow

add a simple rule set (AWS managed rules) if required by lab

#########################################################################

Step 10 — Secret origin header (defense-in-depth)

85-cloudfront.tf will use it, and 95-origin_cloaking_rules.tf will enforce it.

Create:

random_password.origin_header_value (long random string)

Header name: X-Origin-Verify (clean + professional)

#######################################################################

Step 11 — CloudFront distribution in front of ALB

90-cloudfront.tf

Create:

aws_cloudfront_distribution.cf

Key settings:

Origin domain = aws_lb.alb.dns_name

Origin protocol policy: https-only

Add custom origin header:

X-Origin-Verify: random_password.origin_header_value.result

Attach WAF:

web_acl_id = aws_wafv2_web_acl.cf_waf.arn

Viewer cert:

acm_certificate_arn = aws_acm_certificate.cf_cert.arn (or the validation resource arn)

ssl_support_method = "sni-only"

############################################################

Step 12 — Origin cloaking at ALB (SG + listener rules)

You already did SG prefix list ingress in Step 3.

Now add listener rules in:

95-origin_cloaking_rules.tf

Rules on aws_lb_listener.https:

If header matches → forward to TG

Else → fixed 403

That enforces “even if someone reaches ALB, no header = no service”.

##############################################################

Step 13 — Route53 points ONLY to CloudFront

97-route53_to_cloudfront.tf

Create:

aws_route53_record.apex_to_cf (A alias → CF)

aws_route53_record.app_to_cf (A alias → CF)

######################################################################

🔎 When to Use aws.use1

Only use the alias for:

aws_acm_certificate.cf_cert

aws_acm_certificate_validation.cf_cert_validation

aws_wafv2_web_acl.cf_waf

Example:

resource "aws_acm_certificate" "cf_cert" {
  provider          = aws.use1
  domain_name       = var.domain_name
  validation_method = "DNS"
}
resource "aws_wafv2_web_acl" "cf_waf" {
  provider = aws.use1
  scope    = "CLOUDFRONT"
}
⚠️ Important Rule

Do NOT use provider = aws.use1 for:

ALB

EC2

RDS

VPC

Security groups

Those must stay in Tokyo.

🧠 Why This Matters

CloudFront is global but its viewer certificate must exist in us-east-1.

WAF with scope = "CLOUDFRONT" is also managed in us-east-1.

Everything else lives in Tokyo.