############################################
# IAM: EC2 Role + Instance Profile (App VM)
############################################

resource "aws_iam_role" "chewbacca_ec2_role01" {
  name = "${var.project_name}-ec2-role01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "chewbacca_ec2_profile01" {
  name = "${var.project_name}-ec2-profile01"
  role = aws_iam_role.chewbacca_ec2_role01.name
}
