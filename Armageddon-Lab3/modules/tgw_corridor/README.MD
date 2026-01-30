modules/tgw_corridor

Purpose: Build the controlled corridor: TGW Tokyo + TGW SP + peering + routes + SG rule. 

3a_lab

 

Diagram


Inputs:

tokyo_vpc_id, tokyo_vpc_cidr, tokyo_private_route_table_ids

sp_vpc_id, sp_vpc_cidr, sp_private_route_table_ids

tokyo_rds_sg_id (so it can add the inbound rule)

regions: ap-northeast-1, sa-east-1

Contains:

TGW in Tokyo

TGW in São Paulo

VPC attachments (each VPC to its local TGW)

TGW peering (request + accept)

Routes:

SP private RTs: tokyo_vpc_cidr -> sp_tgw

Tokyo private RTs: sp_vpc_cidr -> tokyo_tgw

Tokyo RDS SG rule: allow inbound 3306 from São Paulo VPC CIDR (because SG referencing across VPCs isn’t the pattern you want here) 

3a_lab

Outputs (optional but nice):

tokyo_tgw_id

sp_tgw_id

tgw_peering_attachment_id