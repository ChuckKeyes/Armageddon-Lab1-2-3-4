# data "terraform_remote_state" "tokyo" {
#   backend = "s3"

#   config = {
#     bucket = "YOUR-TF-STATE-BUCKET"
#     key    = "tokyo/terraform.tfstate"
#     region = "us-east-1"
#   }
# }
