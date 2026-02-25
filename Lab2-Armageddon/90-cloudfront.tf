############################################
# Step 11 — CloudFront distribution in front of ALB
############################################

resource "aws_cloudfront_distribution" "cf" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.project_name} CloudFront"

  # Your custom domain for CloudFront (ex: www.keyescloudsolutions.com)
  aliases = [local.app_fqdn]

  # Attach CloudFront WAF (created in us-east-1)
  web_acl_id = aws_wafv2_web_acl.cf_waf.arn

  # ---------------- ORIGIN: ALB ----------------
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "alb-origin-${var.project_name}"

    # Secret origin header (defense-in-depth)
    custom_header {
      name  = var.origin_header_name               # default "X-Origin-Verify"
      value = random_password.origin_header_value.result
    }

    # ALB is a custom origin
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"

       origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # ---------------- DEFAULT CACHE BEHAVIOR ----------------
  default_cache_behavior {
    target_origin_id       = "alb-origin-${var.project_name}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    compress = true

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "all"
      }
    }
  }

  # ---------------- RESTRICTIONS ----------------
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # ---------------- VIEWER CERT (us-east-1 ACM) ----------------
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cf_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Ensure validation finishes before CloudFront tries to use the cert
  depends_on = [aws_acm_certificate_validation.cf_cert_validation]

  tags = merge(var.tags, {
    Name = "${var.project_name}-cloudfront"
  })
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cf.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cf.id
}