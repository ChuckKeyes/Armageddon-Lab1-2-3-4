resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_vpc_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id

  vpc_id = aws_vpc.this.id

  subnet_ids = [
    aws_subnet.chewbacca_private_subnet01.id,
    aws_subnet.chewbacca_private_subnet02.id
  ]

  tags = {
    Name = "lab3cek-tokyo-vpc-attach"
  }
}
