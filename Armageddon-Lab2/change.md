========================
LAB2 — REFERENCE FIXES (DO THESE)
========================

aws_security_group.chewbacca_alb_sg01  ->  aws_security_group.alb_sg
aws_lb_listener.chewbacca_https_listener01  ->  aws_lb_listener.https
aws_lb_target_group.chewbacca_tg01  ->  aws_lb_target_group.tg
aws_lb.chewbacca_alb01  ->  aws_lb.alb

random_password.chewbacca_origin_header_value01  ->  random_password.origin_header_value

aws_wafv2_web_acl.chewbacca_cf_waf01  ->  aws_wafv2_web_acl.cf_waf
aws_cloudfront_distribution.chewbacca_cf01  ->  aws_cloudfront_distribution.cf

local.chewbacca_zone_id  ->  local.zone_id

key_name = "Lab1c_keypair.pem"  ->  key_name = "YOUR_REAL_KEYPAIR_NAME"


========================
LAB2 — LABEL CLEANUP (OPTIONAL; ONLY IF NO EXISTING STATE)
========================

data "aws_ec2_managed_prefix_list" "chewbacca_cf_origin_facing01"  ->  data "aws_ec2_managed_prefix_list" "cf_origin_facing"
resource "aws_security_group_rule" "chewbacca_alb_ingress_cf44301"  ->  resource "aws_security_group_rule" "alb_ingress_cf_443"
resource "random_password" "chewbacca_origin_header_value01"  ->  resource "random_password" "origin_header_value"
resource "aws_lb_listener_rule" "chewbacca_require_origin_header01"  ->  resource "aws_lb_listener_rule" "require_origin_header"
resource "aws_lb_listener_rule" "chewbacca_default_block01"  ->  resource "aws_lb_listener_rule" "default_block"

resource "aws_cloudfront_distribution" "chewbacca_cf01"  ->  resource "aws_cloudfront_distribution" "cf"
resource "aws_wafv2_web_acl" "chewbacca_cf_waf01"  ->  resource "aws_wafv2_web_acl" "cf_waf"

resource "aws_route53_record" "chewbacca_apex_to_cf01"  ->  resource "aws_route53_record" "apex_to_cf"
resource "aws_route53_record" "chewbacca_app_to_cf01"  ->  resource "aws_route53_record" "app_to_cf"


========================
DELETE THIS LINE (INVALID TERRAFORM)
========================

var.cloudfront_acm_cert_arn = aws_acm_certificate.cf_cert.arn   ->   (DELETE ENTIRE LINE)
