locals { name_prefix = var.project_name }

resource "aws_instance" "this" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile = var.instance_profile_name != "" ? var.instance_profile_name : null

  user_data = var.user_data_path != "" ? file(var.user_data_path) : null

  tags = { Name = "${local.name_prefix}-ec201" }
}
