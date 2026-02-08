modules/saopaulo_compute

Purpose: São Paulo is compute-only (NO DB). 

3a_lab

 

Readme


Contains:

SP VPC + subnets + NAT/routing

ALB/ASG/EC2 app tier

CloudFront origin behavior bits if you’re doing it inside this stack

Outputs:

sp_vpc_id

sp_vpc_cidr

sp_private_route_table_ids

sp_app_sg_id

sp_tgw_name_prefix (optional)

liberdade_tgw_id = "tgw-0dee9825b3fbf81e7"
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab3-Armageddon/Sao-Paulo$ aws ec2 describe-transit-gateway-peering-attachments \
>   --region sa-east-1 \
>   --query "TransitGatewayPeeringAttachments[?TransitGatewayAttachmentId=='tgw-attach-055259c3719027162'].{Id:TransitGatewayAttachmentId,State:State}" \
>   --output table
-----------------------------------------------
|  DescribeTransitGatewayPeeringAttachments   |
+-------------------------------+-------------+
|              Id               |    State    |
+-------------------------------+-------------+
|  tgw-attach-055259c3719027162 |  available  |
+-------------------------------+-------------+

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab3-Armageddon/Sao-Paulo$ aws ec2 describe-transit-gateway-vpc-attachments \
>   --region sa-east-1 \
>   --query "TransitGatewayVpcAttachments[].{Id:TransitGatewayAttachmentId,VpcId:VpcId,State:State}" \
>   --output table
------------------------------------------------------------------------
|                 DescribeTransitGatewayVpcAttachments                 |
+-------------------------------+------------+-------------------------+
|              Id               |   State    |          VpcId          |
+-------------------------------+------------+-------------------------+
|  tgw-attach-0bb322a01d9ae42be |  available |  vpc-07d3adc5241ea7c0e  |
+-------------------------------+------------+-------------------------+

ami-0f85876b1aff99dde
sae1-az2 (sa-east-1b)
sae1-az1 (sa-east-1a)
sae1-az3 (sa-east-1c)
"10.20.1.0/24"

var.ami_id → ami-0f85876b1aff99dde

var.saopaulo_ami_id → ami-0f85876b1aff99dde

var.saopaulo_az1 → sa-east-1a

var.saopaulo_az2 → sa-east-1b

var.saopaulo_private_subnet_cidrs → ["10.20.10.0/24","10.20.11.0/24"]

var.saopaulo_public_subnet_cidrs → ["10.20.20.0/24","10.20.21.0/24"]

var.saopaulo_vpc_cidr → 10.20.0.0/16