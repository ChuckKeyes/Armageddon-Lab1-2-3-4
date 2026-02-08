Outputs:


tokyo_private_route_table_ids = [
  "rtb-0989740df1a85b2fe",
tokyo_private_route_table_ids = [
  "rtb-0989740df1a85b2fe",
  "rtb-0989740df1a85b2fe",
]
tokyo_rds_sg_id = "sg-09a45b1a0ea1a1978"
tokyo_rds_sg_id = "sg-09a45b1a0ea1a1978"
tokyo_to_saopaulo_tgw_attachment_id = "tgw-attach-055259c3
-------------------------------------------------------------------------
|               DescribeTransitGatewayPeeringAttachments                |
+----------------+--------------------------------+---------------------+
| AccepterRegion |              Id                |        State        |
+----------------+--------------------------------+---------------------+
|  sa-east-1     |  tgw-attach-055259c3719027162  |  pendingAcceptance  |
+----------------+--------------------------------+---------------------+

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab3-Armageddon/Tokyo$ aws ec2 describe-transit-gateway-vpc-attachments \
>   --region ap-northeast-1 \
>   --query "TransitGatewayVpcAttachments[].{Id:TransitGatewayAttachmentId,VpcId:VpcId,State:State}" \
>   --output table
------------------------------------------------------------------------
|                 DescribeTransitGatewayVpcAttachments                 |
+-------------------------------+------------+-------------------------+
|              Id               |   State    |          VpcId          |
+-------------------------------+------------+-------------------------+
|  tgw-attach-005f6f7a492733bfa |  available |  vpc-09da5b5fdbf95f527  |
+-------------------------------+------------+-------------------------+