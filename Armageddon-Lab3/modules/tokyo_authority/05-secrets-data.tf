variable "tokyo_db_secret_name" {
  description = "Name of the existing Secrets Manager secret for Tokyo DB creds"
  type        = string
}

data "aws_secretsmanager_secret" "tokyo_db_secret" {
  provider = aws
  name = var.tokyo_db_secret_name
}


#######################  Restore the secret  #############################

# aws secretsmanager restore-secret \
#   --secret-id "armageddon-tokyo/tokyo/rds-v7" \
#   --region ap-northeast-1


# Then confirm

# aws secretsmanager describe-secret \
#   --secret-id "armageddon-tokyo/tokyo/rds-v7" \
#   --region ap-northeast-1

#   NEW SECRET NAME

# tokyo_db_secret_name = "armageddon-tokyo/tokyo/rds-v8"


# terraform import module.tokyo_authority.aws_lb_target_group.tokyo_app_tg arn:aws:elasticloadbalancing:ap-northeast-1:557690581423:targetgroup/lab3cek-tokyo-app-tg/d050f161d294497f
