resource "aws_iam_role_policy_attachment" "attach_lp_params" {
  role       = aws_iam_role.ceklab1_ec2_role01.name
  policy_arn = module.bonus_a.lp_read_params_policy_arn
}


resource "aws_iam_role_policy_attachment" "attach_lp_secret" {
  count = module.bonus_a.lp_read_secret_policy_arn != null ? 1 : 0

  role       = aws_iam_role.ceklab1_ec2_role01.name
  policy_arn = module.bonus_a.lp_read_secret_policy_arn
}


resource "aws_iam_role_policy_attachment" "attach_lp_cwlogs" {
  role       = aws_iam_role.ceklab1_ec2_role01.name
  policy_arn = module.bonus_a.lp_cwlogs_policy_arn
}
