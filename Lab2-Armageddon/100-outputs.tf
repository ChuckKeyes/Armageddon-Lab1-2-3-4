output "vpc_id" {
  value = aws_vpc.this.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_app_subnet_ids" {
  value = [for s in aws_subnet.private_app : s.id]
}

output "private_db_subnet_ids" {
  value = [for s in aws_subnet.private_db : s.id]
}

output "azs" {
  value = var.azs
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "rds_endpoint" {
  value = aws_db_instance.db.address
}

output "rds_port" {
  value = aws_db_instance.db.port
}

# output "alb_dns_name" {
#   value = aws_lb.alb.dns_name
# }

output "app_fqdn" {
  value = local.app_fqdn
}

output "domain_name" {
  value = var.domain_name
}

# output "cloudfront_distribution_id" {
#   value = aws_cloudfront_distribution.cf.id
# }

# output "cloudfront_domain_name" {
#   value = aws_cloudfront_distribution.cf.domain_name
# }

# output "cloudfront_waf_arn" {
#   value = aws_wafv2_web_acl.cf_waf.arn
# }

output "cloudfront_waf_id" {
  value = aws_wafv2_web_acl.cf_waf.id
}