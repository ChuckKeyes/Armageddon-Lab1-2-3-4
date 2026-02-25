variable "project_name" {
  type        = string
  description = "Name prefix for resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where endpoints will be created."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for interface endpoints and private EC2."
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Route table IDs used by private subnets (for S3 gateway endpoint)."
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI for the private EC2 instance."
}

variable "ec2_instance_type" {
  type        = string
  description = "Instance type for the private EC2 instance."
  default     = "t3.micro"
}

variable "ec2_security_group_id" {
  type        = string
  description = "Security group ID for the EC2 instance."
}

variable "iam_instance_profile_name" {
  type        = string
  description = "Existing instance profile name to attach to the private EC2."
}

variable "secret_arn" {
  type        = string
  description = "Exact Secrets Manager secret ARN to allow GetSecretValue. (No wildcards)"
}

variable "cloudwatch_log_group_arn" {
  type        = string
  description = "CloudWatch log group ARN for least-privilege logs write."
}

variable "create_private_instance" {
  type        = bool
  description = "Whether to create the private EC2 instance in this module."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to resources."
  default     = {}
}
