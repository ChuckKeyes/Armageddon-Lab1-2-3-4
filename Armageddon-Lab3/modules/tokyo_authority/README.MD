modules/tokyo_authority

Purpose: Tokyo is the PHI authority (DB lives here only). 

Readme


Contains:

Tokyo VPC + subnets + routing (your existing 15 files get “absorbed” here)

RDS (Tokyo only) + subnet group + parameter group

Secrets Manager / SSM parameters for DB endpoint/creds (authoritative)

App tier (optional if your Tokyo also runs app)

Outputs (the “contract” São Paulo will consume):

tokyo_vpc_id

tokyo_vpc_cidr

tokyo_private_route_table_ids

tokyo_rds_endpoint

tokyo_rds_sg_id
########################################################################

1) Remove these from tfvars

In tokyo.auto.tfvars: delete (or comment) anything that looks like an output/ID list, like:

tokyo_private_route_table_ids = [...]

tokyo_vpc_id = "vpc-..."

tokyo_rds_sg_id = "sg-..."

etc.

In terraform.tfvars: remove sao_paulo_vpc_cidr unless your root actually uses it.

2) Only keep true “inputs” in tfvars

Inputs are things like:

CIDRs

AZ names

instance types

names/prefixes

feature flags like enable_tokyo_integration

#####################################################################################

Outputs:

tokyo_private_route_table_ids = [
  "rtb-0029ea9f5ecc56557",
]
tokyo_rds_sg_id = "sg-04009ac9e7051b5b5"
tokyo_vpc_cidr = "10.10.0.0/16"
tokyo_vpc_id = "vpc-07731da43ab3eb9a1"
############################################################################################
aws ec2 describe-transit-gateways \
  --region ap-northeast-1 \
  --query 'TransitGateways[*].[TransitGatewayId,State]' \
  --output table
|        DescribeTransitGateways       |
+------------------------+-------------+
|  tgw-03055e9234c26b8ab |  deleted    |
|  tgw-04a758504cdbb5c89 |  available  |
+------------------------+-------------+
#######################################################################################

aws ec2 describe-transit-gateway-vpc-attachments \
  --region ap-northeast-1 \
  --query 'TransitGatewayVpcAttachments[*].[TransitGatewayAttachmentId,State,VpcId]' \
  --output table


######################################################################################

aws ec2 search-transit-gateway-routes \
  --region ap-northeast-1 \
  --transit-gateway-route-table-id tgw-rtb-xxxxxxxx \
  --filters Name=state,Values=active \
  --query 'Routes[*].[DestinationCidrBlock,Type]' \
  --output table

###################################################################################


>   --region sa-east-1 \
>   --filters Name=transit-gateway-id,Values=tgw-0ccc88e31b142add9 \
>   --query 'TransitGatewayVpcAttachments[*].[TransitGatewayAttachmentId,State,VpcId]' \
>   --output table
4a-402a-b7ff-6eddf50f2ec3------------------------------------------------------------------------
|                 DescribeTransitGatewayVpcAttachments                 |
+-------------------------------+------------+-------------------------+
|  tgw-attach-0803cb14fa20177af |  available |  vpc-0adc3b8e1d8b72d7c  |
+-------------------------------+------------+-------------------------+

####################################################################################

aws ec2 create-transit-gateway-peering-attachment \
  --region ap-northeast-1 \
  --transit-gateway-id tgw-04a758504cdbb5c89 \
  --peer-transit-gateway-id tgw-0ccc88e31b142add9 \
  --peer-region sa-east-1 \
  --tag-specifications 'ResourceType=transit-gateway-attachment,Tags=[{Key=Name,Value=lab3cek-tokyo-to-saopaulo-peer}]' \
  --query 'TransitGatewayPeeringAttachment.TransitGatewayAttachmentId' \
  --output text


##########################################################################################

aws ec2 accept-transit-gateway-peering-attachment \
  --region sa-east-1 \
  --transit-gateway-attachment-id tgw-attach-XXXXXXXX \
  --output json



aws ec2 describe-transit-gateway-peering-attachments \
  --region ap-northeast-1 \
  --transit-gateway-attachment-ids tgw-attach-XXXXXXXX \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State]' \
  --output table

aws ec2 describe-transit-gateway-route-tables \
  --region ap-northeast-1 \
  --filters Name=transit-gateway-id,Values=tgw-04a758504cdbb5c89 \
  --query 'TransitGatewayRouteTables[*].[TransitGatewayRouteTableId,State]' \
  --output table


aws ec2 create-transit-gateway-route \
  --region ap-northeast-1 \
  --transit-gateway-route-table-id <TOKYO_TGW_RTB_ID> \
  --destination-cidr-block 10.20.0.0/16 \
  --transit-gateway-attachment-id tgw-attach-XXXXXXXX



aws ec2 create-transit-gateway-route \
  --region sa-east-1 \
  --transit-gateway-route-table-id tgw-rtb-08c344798f54cbb5a \
  --destination-cidr-block 10.10.0.0/16 \
  --transit-gateway-attachment-id tgw-attach-XXXXXXXX

#######################################################################

Outputs:

saopaulo_private_subnet_ids = [
  "subnet-06517d6622feb86b7",
  "subnet-0c108d550903f04f0",
]
saopaulo_tgw_id = "tgw-0ccc88e31b142add9"
saopaulo_tgw_vpc_attachment_id = "tgw-attach-0803cb14fa20177af"
saopaulo_vpc_cidr = "10.20.0.0/16"
saopaulo_vpc_id = "vpc-0adc3b8e1d8b72d7c"
tokyo_private_route_table_ids = [
  "rtb-0029ea9f5ecc56557",
]
tokyo_rds_sg_id = "sg-04009ac9e7051b5b5"
tokyo_vpc_cidr = "10.10.0.0/16"
tokyo_vpc_id = "vpc-07731da43ab3eb9a1"

#########################################################################


aws ec2 describe-transit-gateway-peering-attachments \
  --region ap-northeast-1 \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State,RequesterTgwInfo.TransitGatewayId,AccepterTgwInfo.TransitGatewayId]' \
  --output table
-------------------------------------------------------------------------------------------------
|                           DescribeTransitGatewayPeeringAttachments                            |
+------------------------------+------------+-------------------------+-------------------------+
|  tgw-attach-0f74b721d4c4197a4|  available |  tgw-04a758504cdbb5c89  |  tgw-0ccc88e31b142add9  |
+------------------------------+------------+-------------------------+-------------------------+

#######################################################################################################

aws ec2 describe-transit-gateway-peering-attachments \
  --region sa-east-1 \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State,RequesterTgwInfo.TransitGatewayId,AccepterTgwInfo.TransitGatewayId]' \
  --output table
5-7bb2-4eac-a755-02563cd33ea5-------------------------------------------------------------------------------------------------
|                           DescribeTransitGatewayPeeringAttachments                            |
+------------------------------+------------+-------------------------+-------------------------+
|  tgw-attach-0f74b721d4c4197a4|  available |  tgw-04a758504cdbb5c89  |  tgw-0ccc88e31b142add9  |
+------------------------------+------------+-------------------------+-------------------------+

########################################################################################################

aws ec2 describe-transit-gateway-route-tables \
  --region ap-northeast-1 \
  --filters Name=transit-gateway-id,Values=tgw-04a758504cdbb5c89 \
  --query 'TransitGatewayRouteTables[*].[TransitGatewayRouteTableId,State]' \
  --output table
-a755-02563cd33ea5--------------------------------------------
|     DescribeTransitGatewayRouteTables    |
+----------------------------+-------------+
|  tgw-rtb-060120fefacd8695e |  available  |
+----------------------------+-------------+

#######################################################################
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab3$ aws ec2 search-transit-gateway-routes \
>   --region sa-east-1 \
>   --transit-gateway-route-table-id tgw-rtb-08c344798f54cbb5a \
>   --filters Name=state,Values=active \
>   --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
>   --output table
------------------------------------------
|       SearchTransitGatewayRoutes       |
+---------------+--------------+---------+
|  10.10.0.0/16 |  static      |  active |
|  10.20.0.0/16 |  propagated  |  active |
+---------------+--------------+---------+

#############################################################################

aws ec2 search-transit-gateway-routes \
  --region ap-northeast-1 \
  --transit-gateway-route-table-id tgw-rtb-060120fefacd8695e \
  --filters Name=state,Values=active \
  --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
  --output table
------------------------------------------
|       SearchTransitGatewayRoutes       |
+---------------+--------------+---------+
|  10.10.0.0/16 |  propagated  |  active |
|  10.20.0.0/16 |  static      |  active |
+---------------+--------------+---------+
#################################################################################

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab3$ aws ec2 search-transit-gateway-routes \
>   --region sa-east-1 \
>   --transit-gateway-route-table-id tgw-rtb-08c344798f54cbb5a \
>   --filters Name=state,Values=active \
>   --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
>   --output table
-a755-02563cd33ea5------------------------------------------
|       SearchTransitGatewayRoutes       |
+---------------+--------------+---------+
|  10.10.0.0/16 |  static      |  active |
|  10.20.0.0/16 |  propagated  |  active |
+---------------+--------------+---------+

#########################################################################################

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab3$ aws ec2 describe-route-tables \
>   --region ap-northeast-1 \
>   --route-table-ids rtb-0029ea9f5ecc56557 \
>   --query 'RouteTables[0].Routes[*].[DestinationCidrBlock,TransitGatewayId,State]' \
>   --output table
-----------------------------------------------------
|                DescribeRouteTables                |
+---------------+-------------------------+---------+
|  10.10.0.0/16 |  None                   |  active |
|  10.20.0.0/16 |  tgw-04a758504cdbb5c89  |  active |
+---------------+-------------------------+---------+

###################################################################################

aws ec2 describe-route-tables \
  --region sa-east-1 \
  --route-table-ids rtb-02cd87950e5b51a10 \
  --query 'RouteTables[0].Routes[*].[DestinationCidrBlock,TransitGatewayId,State]' \
  --output table
-----------------------------------------------------
|                DescribeRouteTables                |
+---------------+-------------------------+---------+
|  10.10.0.0/16 |  tgw-0ccc88e31b142add9  |  active |
|  10.20.0.0/16 |  None                   |  active |
+---------------+-------------------------+---------+

#########################################################################################

São Paulo private RT (rtb-02cd87950e5b51a10)

✅ 10.10.0.0/16 → tgw-0ccc88e31b142add9 (active)

✅ local 10.20.0.0/16 (active)

Tokyo private RT (you already showed)

✅ 10.20.0.0/16 → tgw-04a758504cdbb5c89 (active)

TGW peering + TGW routes (you already showed)

✅ Peering attachment available

✅ TGW route tables have static active routes for the opposite CIDR

##########################################################################################

