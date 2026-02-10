1️⃣ Verify Transit Gateways exist and are available

Tokyo
aws ec2 describe-transit-gateways \
  --region ap-northeast-1 \
  --query 'TransitGateways[*].[TransitGatewayId,State,Description]' \
  --output table


############################################################################

São Paulo
aws ec2 describe-transit-gateways \
  --region sa-east-1 \
  --query 'TransitGateways[*].[TransitGatewayId,State,Description]' \
  --output table


#################################################################################

✅ Expect State = available for both TGWs.


###############################################################################

2️⃣ Verify VPC attachments to each TGW

Tokyo TGW → Tokyo VPC
aws ec2 describe-transit-gateway-vpc-attachments \
  --region ap-northeast-1 \
  --query 'TransitGatewayVpcAttachments[*].[TransitGatewayAttachmentId,State,VpcId]' \
  --output table


################################################################################

São Paulo TGW → São Paulo VPC     ✅ Expect State = available.

aws ec2 describe-transit-gateway-vpc-attachments \
  --region sa-east-1 \
  --query 'TransitGatewayVpcAttachments[*].[TransitGatewayAttachmentId,State,VpcId]' \
  --output table


######################################################################################

3️⃣ Verify TGW peering attachment (both regions)

Tokyo

aws ec2 describe-transit-gateway-peering-attachments \
  --region ap-northeast-1 \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State,RequesterTgwInfo.TransitGatewayId,AccepterTgwInfo.TransitGatewayId]' \
  --output table

#########################################################################################

São Paulo

aws ec2 describe-transit-gateway-peering-attachments \
  --region sa-east-1 \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State,RequesterTgwInfo.TransitGatewayId,AccepterTgwInfo.TransitGatewayId]' \
  --output table


####################################################################################

✅ Expect:

Same tgw-attach-… ID in both regions

State = available

#####################################################################################

4️⃣ Verify TGW route tables

List TGW route tables (Tokyo)

aws ec2 describe-transit-gateway-route-tables \
  --region ap-northeast-1 \
  --filters Name=transit-gateway-id,Values=<TOKYO_TGW_ID> \
  --query 'TransitGatewayRouteTables[*].[TransitGatewayRouteTableId,State]' \
  --output table


########################################################################################

List TGW route tables (São Paulo)

aws ec2 describe-transit-gateway-route-tables \
  --region sa-east-1 \
  --filters Name=transit-gateway-id,Values=<SAOPAULO_TGW_ID> \
  --query 'TransitGatewayRouteTables[*].[TransitGatewayRouteTableId,State]' \
  --output table


############################################################################################

5️⃣ Verify TGW routes (critical proof)

Tokyo TGW route table

aws ec2 search-transit-gateway-routes \
  --region ap-northeast-1 \
  --transit-gateway-route-table-id <TOKYO_TGW_RTB_ID> \
  --filters Name=state,Values=active \
  --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
  --output table


###############################################################################################

✅ Must include:

10.20.0.0/16 | static | active

10.10.0.0/16 | propagated | active

###############################################################################################

São Paulo TGW route table

aws ec2 search-transit-gateway-routes \
  --region sa-east-1 \
  --transit-gateway-route-table-id <SAOPAULO_TGW_RTB_ID> \
  --filters Name=state,Values=active \
  --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
  --output table


##############################################################################################

✅ Must include:

10.10.0.0/16 | static | active

10.20.0.0/16 | propagated | active

##############################################################################################

6️⃣ Verify VPC route tables point to TGW

Tokyo private route table

aws ec2 describe-route-tables \
  --region ap-northeast-1 \
  --route-table-ids <TOKYO_PRIVATE_RTB_ID> \
  --query 'RouteTables[0].Routes[*].[DestinationCidrBlock,TransitGatewayId,State]' \
  --output table


#######################################################################################

✅ Must include:

10.20.0.0/16 → Tokyo TGW

######################################################################################

São Paulo private route table

aws ec2 describe-route-tables \
  --region sa-east-1 \
  --route-table-ids <SAOPAULO_PRIVATE_RTB_ID> \
  --query 'RouteTables[0].Routes[*].[DestinationCidrBlock,TransitGatewayId,State]' \
  --output table


########################################################################################

✅ Must include:

10.10.0.0/16 → São Paulo TGW
#######################################################################################

Verification Result

If all commands above return active routes and available attachments, then:

✅ Transit Gateway peering is correctly established
✅ Routing is correct in both directions
✅ The control plane is fully validated