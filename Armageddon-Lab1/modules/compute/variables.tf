variable "project_name" { type = string }

variable "ec2_ami_id" { type = string }
variable "ec2_instance_type" { type = string }

variable "public_subnet_id" { type = string }
variable "ec2_sg_id" { type = string }

# Optional: pass "" to skip attaching a profile
variable "instance_profile_name" {
  type    = string
  default = ""
}

variable "user_data_path" {
  type    = string
  default = ""
}
