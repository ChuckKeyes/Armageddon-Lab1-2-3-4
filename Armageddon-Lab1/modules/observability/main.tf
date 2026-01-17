locals { name_prefix = var.project_name }

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ec2/${local.name_prefix}-rds-app"
  retention_in_days = var.retention_in_days
  tags              = { Name = "${local.name_prefix}-log-group01" }
}

resource "aws_cloudwatch_metric_alarm" "db_alarm" {
  alarm_name          = "${local.name_prefix}-db-connection-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1

  metric_name = "DBConnectionErrors"
  namespace   = "Lab/RDSApp"
  period      = 300
  statistic   = "Sum"
  threshold   = 3

  alarm_actions = [var.sns_topic_arn]

  tags = { Name = "${local.name_prefix}-alarm-db-fail" }
}
