variable "aws_region" { type = string }
variable "project_name" { type = string }

variable "ec2_ami_id" { type = string }
variable "ec2_instance_type" { type = string }

# Optional: set to "" if you don't want user_data yet
variable "user_data_path" {
  type    = string
  default = ""
}
