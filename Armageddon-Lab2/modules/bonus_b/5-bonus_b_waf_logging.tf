############################################
# Bonus B - WAF Logging (CloudWatch Logs OR S3 OR Firehose)
# One destination per Web ACL, choose via var.waf_log_destination.
############################################

data "aws_caller_identity" "current" {}

############################################
# Option 1: CloudWatch Logs destination
############################################

resource "aws_cloudwatch_log_group" "waf_log_group" {
  count = var.enable_waf && var.waf_log_destination == "cloudwatch" ? 1 : 0

  # AWS requires WAF log group names start with aws-waf-logs-
  name              = "aws-waf-logs-${var.project_name}-webacl"
  retention_in_days = var.waf_log_retention_days

  tags = {
    Name = "${var.project_name}-waf-log-group"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_cloudwatch" {
  count = var.enable_waf && var.waf_log_destination == "cloudwatch" ? 1 : 0

  resource_arn = aws_wafv2_web_acl.waf[0].arn
  log_destination_configs = [
    aws_cloudwatch_log_group.waf_log_group[0].arn
  ]

  depends_on = [aws_wafv2_web_acl.waf]
}

############################################
# Option 2: S3 destination (direct)
############################################

resource "aws_s3_bucket" "waf_logs_bucket" {
  count = var.enable_waf && var.waf_log_destination == "s3" ? 1 : 0

  bucket = "aws-waf-logs-${var.project_name}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-waf-logs-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "waf_logs_pab" {
  count = var.enable_waf && var.waf_log_destination == "s3" ? 1 : 0

  bucket                  = aws_s3_bucket.waf_logs_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_s3" {
  count = var.enable_waf && var.waf_log_destination == "s3" ? 1 : 0

  resource_arn = aws_wafv2_web_acl.waf[0].arn
  log_destination_configs = [
    aws_s3_bucket.waf_logs_bucket[0].arn
  ]

  depends_on = [aws_wafv2_web_acl.waf]
}

############################################
# Option 3: Firehose destination (stream then store)
############################################

resource "aws_s3_bucket" "firehose_waf_dest_bucket" {
  count = var.enable_waf && var.waf_log_destination == "firehose" ? 1 : 0

  bucket = "${var.project_name}-waf-firehose-dest-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-waf-firehose-dest-bucket"
  }
}

resource "aws_iam_role" "firehose_role" {
  count = var.enable_waf && var.waf_log_destination == "firehose" ? 1 : 0

  name = "${var.project_name}-waf-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  count = var.enable_waf && var.waf_log_destination == "firehose" ? 1 : 0

  name = "${var.project_name}-waf-firehose-policy"
  role = aws_iam_role.firehose_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ]
      Resource = [
        aws_s3_bucket.firehose_waf_dest_bucket[0].arn,
        "${aws_s3_bucket.firehose_waf_dest_bucket[0].arn}/*"
      ]
    }]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "waf_firehose" {
  count       = var.enable_waf && var.waf_log_destination == "firehose" ? 1 : 0
  name        = "aws-waf-logs-${var.project_name}-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role[0].arn
    bucket_arn = aws_s3_bucket.firehose_waf_dest_bucket[0].arn
    prefix     = "waf-logs/"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_firehose" {
  count = var.enable_waf && var.waf_log_destination == "firehose" ? 1 : 0

  resource_arn = aws_wafv2_web_acl.waf[0].arn
  log_destination_configs = [
    aws_kinesis_firehose_delivery_stream.waf_firehose[0].arn
  ]

  depends_on = [aws_wafv2_web_acl.waf]
}
