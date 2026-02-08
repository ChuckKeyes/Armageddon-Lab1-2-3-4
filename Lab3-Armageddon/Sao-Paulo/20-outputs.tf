output "liberdade_tgw_id" {
  value = aws_ec2_transit_gateway.liberdade_tgw01.id
}
output "saopaulo_ec2_sg_id" {
  value = aws_security_group.lab3cek_saopaulo_ec2_sg.id
}
