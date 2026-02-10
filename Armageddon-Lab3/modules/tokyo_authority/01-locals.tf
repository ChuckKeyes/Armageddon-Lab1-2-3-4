locals {
  tokyo_vpc_id = aws_vpc.chewbacca_vpc01.id

  tokyo_private_subnet_ids = [
    aws_subnet.chewbacca_private_subnet01.id,
    aws_subnet.chewbacca_private_subnet02.id
  ]

  tokyo_public_subnet_ids = [
    aws_subnet.chewbacca_public_subnet01.id,
    aws_subnet.chewbacca_public_subnet02.id
  ]

  tokyo_app_subnet_id = aws_subnet.chewbacca_public_subnet01.id
}
