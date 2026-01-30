############################################
# IAM: Managed policy attachments
############################################

# SSM = no SSH keys needed (Session Manager)
resource "aws_iam_role_policy_attachment" "chewbacca_ec2_ssm_attach" {
  role       = aws_iam_role.chewbacca_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# CloudWatch agent permissions (logs + metrics)
resource "aws_iam_role_policy_attachment" "chewbacca_ec2_cw_agent_attach" {
  role       = aws_iam_role.chewbacca_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
