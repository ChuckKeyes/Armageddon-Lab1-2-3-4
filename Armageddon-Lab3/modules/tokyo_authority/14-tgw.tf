resource "aws_ec2_transit_gateway" "tokyo_tgw" {
  description                     = "lab3cek tokyo tgw"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "lab3cek-tokyo-tgw"
  }
}
