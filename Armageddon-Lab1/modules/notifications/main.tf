locals { name_prefix = var.project_name }

resource "aws_sns_topic" "this" {
  name = "${local.name_prefix}-db-incidents"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}
