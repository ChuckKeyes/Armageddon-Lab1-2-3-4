############################################
# 33-cloudfront.tf
# ACM (us-east-1) + CloudFront Distribution (us-east-1)
############################################

############################
# ACM Certificate (MUST be us-east-1 for CloudFront)
############################
resource "aws_acm_certificate" "cf_cert" {
  provider          = aws.us_east_1
  domain_name       = "www.${var.domain_name}"
  validation_method = "DNS"

  # Optional SAN for apex
  subject_alternative_names = var.enable_apex ? [var.domain_name] : []

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cf-cert"
  })
}

############################
# Certificate validation (DNS records are created in 32-route53.tf)
############################
resource "aws_acm_certificate_validation" "cf_cert_validation" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.cf_cert.arn

  validation_record_fqdns = [
    for r in aws_route53_record.acm_validation : r.fqdn
  ]
}

############################
# CloudFront Distribution
############################
resource "aws_cloudfront_distribution" "app_cdn" {
  provider = aws.us_east_1
  enabled  = true

  # If you want CloudFront to answer on your custom domains
  aliases = var.enable_apex ? ["www.${var.domain_name}", var.domain_name] : ["www.${var.domain_name}"]

  ##########################
  # Origin
  ##########################
  origin {
    domain_name = var.origin_domain_name
    origin_id   = "origin-app"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # change to "https-only" if your origin supports HTTPS
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "origin-app"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  # Basic global distribution settings
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cf_cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # CloudFront needs a default object only for static sites; for apps leave it blank
  # default_root_object = "index.html"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-cdn"
  })
}

############################
# Outputs
############################
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.app_cdn.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.app_cdn.id
}
