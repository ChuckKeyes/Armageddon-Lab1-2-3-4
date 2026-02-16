locals {
  # VPC in this module is aws_vpc.this (from 12-vpc.tf)
  tokyo_vpc_id = aws_vpc.this.id

  # Subnets in this module are still named chewbacca_* (from 3-tokyo_vpc.tf)
  tokyo_private_subnet_ids = [
    aws_subnet.chewbacca_private_subnet01.id,
    aws_subnet.chewbacca_private_subnet02.id
  ]

  tokyo_public_subnet_ids = [
    aws_subnet.chewbacca_public_subnet01.id,
    aws_subnet.chewbacca_public_subnet02.id
  ]

 # EC2 subnet (pick public if it needs internet/public IP)
  tokyo_app_subnet_id = local.tokyo_public_subnet_ids[0]



}







# locals {
#   tokyo_vpc_id = aws_vpc.chewbacca_vpc01.id

#   tokyo_private_subnet_ids = [
#     aws_subnet.chewbacca_private_subnet01.id,
#     aws_subnet.chewbacca_private_subnet02.id
#   ]
  
#   tokyo_subnet_ids = length(var.existing_tokyo_subnet_ids) > 0 ? var.existing_tokyo_subnet_ids : [
#     aws_subnet.tokyo_public_subnet01[0].id,
#     aws_subnet.tokyo_public_subnet02[0].id
#   ]


  # tokyo_public_subnet_ids = [
  #   aws_subnet.chewbacca_public_subnet01.id,
  #   aws_subnet.chewbacca_public_subnet02.id
  # ]

  #tokyo_app_subnet_id = aws_subnet.chewbacca_public_subnet01.id

