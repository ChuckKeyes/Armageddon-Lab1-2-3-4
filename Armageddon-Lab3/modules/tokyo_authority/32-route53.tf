############################################
# 32-route53.tf
# Route 53 zone lookup + ACM DNS validation + CloudFront aliases
############################################

# --- Hosted Zone lookup (recommended: zone already exists) ---
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

locals {
  zone_id = data.aws_route53_zone.primary.zone_id

  # FQDNs we will publish
  www_fqdn  = "www.${var.domain_name}"
  apex_fqdn = var.domain_name
}

############################################
# ACM DNS validation records
# (ACM cert is created in us-east-1 in File D, but Route53 is global)
############################################

# Requires that File D defines:
# resource "aws_acm_certificate" "cf_cert" { provider = aws.us_east_1 ... }
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cf_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# File D should include:
# resource "aws_acm_certificate_validation" "cf_cert_validation" { provider = aws.us_east_1 ... }

############################################
# CloudFront Alias Records (A + AAAA)
############################################

# Requires that File D defines:
# resource "aws_cloudfront_distribution" "app_cdn" { provider = aws.us_east_1 ... }
# CloudFront gives us domain_name + hosted_zone_id for Route53 aliases.

# www A
resource "aws_route53_record" "www_a" {
  zone_id = local.zone_id
  name    = local.www_fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.app_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.app_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# www AAAA (IPv6)
resource "aws_route53_record" "www_aaaa" {
  zone_id = local.zone_id
  name    = local.www_fqdn
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.app_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.app_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# apex A
resource "aws_route53_record" "apex_a" {
  zone_id = local.zone_id
  name    = local.apex_fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.app_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.app_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# apex AAAA
resource "aws_route53_record" "apex_aaaa" {
  zone_id = local.zone_id
  name    = local.apex_fqdn
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.app_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.app_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
