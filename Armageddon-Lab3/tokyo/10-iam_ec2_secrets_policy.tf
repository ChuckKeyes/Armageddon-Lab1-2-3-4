############################################
# IAM: Allow EC2 to read ONE Secrets Manager secret
############################################

resource "aws_iam_policy" "chewbacca_ec2_read_db_secret" {
  name        = "${var.project_name}-ec2-read-db-secret"
  description = "Allow EC2 to read the DB credentials secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ReadDBSecret"
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = aws_secretsmanager_secret.tokyo_db_secret.arn

    }]
  })
}

# resource "aws_iam_role_policy_attachment" "chewbacca_ec2_read_db_secret_attach" {
#   role       = aws_iam_role.chewbacca_ec2_role01.name
#   policy_arn = aws_iam_policy.chewbacca_ec2_read_db_secret.arn
# }

#  iam_instance_profile = aws_iam_instance_profile.chewbacca_ec2_profile01.name
