# output "alb_dns_name" {
#   value = aws_lb.alb.dns_name
# }

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "waf_arn" {
  value = try(aws_wafv2_web_acl.waf[0].arn, null)
}

output "app_fqdn" {
  description = "Application FQDN"
  value       = "${var.app_subdomain}.${var.domain_name}"
}

output "alb_dns_name" {
  description = "DNS name of the public ALB"
  value       = aws_lb.alb.dns_name
}


