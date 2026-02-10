Lab3CEK Tokyo ↔ São Paulo Transit Gateway Corridor
Concept (what you should feel)
Compliance truth

PHI storage stays in Tokyo

Compute can move

Access can be global

Storage cannot

Engineering truth

TGW creates a controlled corridor (Tokyo ↔ São Paulo)

São Paulo is stateless (compute-only)

Tokyo is authoritative (data-owner + policy enforcement)

That’s the lab.

Where Things Go (Root vs Modules)
1) Lab3 ROOT (orchestration + cross-region wiring)

Root owns anything that touches both regions.

Providers (required)

provider "aws" default (optional)

provider "aws" { alias = "tokyo" region = "ap-northeast-1" }

provider "aws" { alias = "saopaulo" region = "sa-east-1" }

Module calls

module "tokyo" using providers = { aws = aws.tokyo }

module "saopaulo_compute" using providers = { aws = aws.saopaulo }

TGW corridor wiring (must be root)

TGW peering

aws_ec2_transit_gateway_peering_attachment (Tokyo requester)

aws_ec2_transit_gateway_peering_attachment_accepter (São Paulo accepter)

TGW route-table routes

Tokyo TGW RT: 10.20.0.0/16 → peering attachment

São Paulo TGW RT: 10.10.0.0/16 → peering attachment

VPC route-table routes

Tokyo private RT: 10.20.0.0/16 → Tokyo TGW

São Paulo private RT: 10.10.0.0/16 → São Paulo TGW

Root inputs (variables)

project_name, tags, environment

tokyo_vpc_cidr = 10.10.0.0/16

saopaulo_vpc_cidr = 10.20.0.0/16

flags (optional): enable_peering, enable_readonly, enable_test_clients

Root outputs (what root should expose)

TGW IDs (Tokyo + São Paulo)

peering attachment id

VPC IDs + CIDRs

private subnet ids

private route table ids

(later) EC2 private IPs for testing

2) modules/tokyo_authority (data owner + policy enforcement)

Tokyo = medical authority region (authoritative storage).

Tokyo networking

VPC, subnets, route tables

security groups

IGW/NAT/endpoints only if needed

Tokyo TGW (lives here)

aws_ec2_transit_gateway (Tokyo)

aws_ec2_transit_gateway_vpc_attachment (Tokyo VPC → Tokyo TGW)

Medical data layer (lives here)

Choose one:

RDS (recommended)

DB subnet group

RDS instance

DB SG

Secrets Manager secrets

or S3 medical-records bucket

Read-only enforcement (should live here)

Because Tokyo owns the data, Tokyo enforces:

DB SG allows only DB port from São Paulo CIDR (10.20.0.0/16)

DB permissions create medical_ro (SELECT only)

Secrets Manager stores read-only creds separately: tokyo/medical_ro

Tokyo outputs (export only what root/spokes need)

tokyo_vpc_id, tokyo_vpc_cidr

tokyo_private_subnet_ids

tokyo_private_route_table_ids

tokyo_tgw_id

tokyo_tgw_vpc_attachment_id

(if RDS) tokyo_rds_endpoint, tokyo_medical_ro_secret_arn

3) modules/saopaulo_compute (compute consumer)

São Paulo = compute-only consumer (read-only client).

São Paulo networking

Liberdade VPC, 2 private subnets, private RT

SGs for client compute

São Paulo TGW (lives here)

aws_ec2_transit_gateway (São Paulo)

aws_ec2_transit_gateway_vpc_attachment (Liberdade VPC → São Paulo TGW)

São Paulo compute (optional, for proof)

1 “client” EC2 (or ASG later)

IAM role: read-only access to tokyo/medical_ro secret (if using RDS)

SSM if you want private access

São Paulo outputs

saopaulo_vpc_id, saopaulo_vpc_cidr

saopaulo_private_subnet_ids

saopaulo_private_route_table_id

saopaulo_tgw_id

saopaulo_tgw_vpc_attachment_id

(later) client private IP

Rule of Thumb (so you don’t drift)

✅ Must be ROOT

TGW peering (attachment + accepter)

anything referencing both regions/modules

✅ Belongs in Tokyo module

medical DB/S3

read-only enforcement (DB user, SG inbound, secret)

✅ Belongs in São Paulo module

client compute + its IAM

anything only in sa-east-1

Verification (TGW-only “corridor proof”)
Control-plane proof (no EC2 required)
Peering is available (both regions)

aws ec2 describe-transit-gateway-peering-attachments \
  --region ap-northeast-1 \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State]' \
  --output table

aws ec2 describe-transit-gateway-peering-attachments \
  --region sa-east-1 \
  --query 'TransitGatewayPeeringAttachments[*].[TransitGatewayAttachmentId,State]' \
  --output table
######################################################################################

TGW route tables have static routes to the opposite CIDR

aws ec2 search-transit-gateway-routes \
  --region ap-northeast-1 \
  --transit-gateway-route-table-id <TOKYO_TGW_RTB_ID> \
  --filters Name=state,Values=active \
  --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
  --output table

aws ec2 search-transit-gateway-routes \
  --region sa-east-1 \
  --transit-gateway-route-table-id <SAOPAULO_TGW_RTB_ID> \
  --filters Name=state,Values=active \
  --query 'Routes[*].[DestinationCidrBlock,Type,State]' \
  --output table


#######################################################################################

VPC private route tables route the opposite CIDR to the local TGW

aws ec2 describe-route-tables \
  --region ap-northeast-1 \
  --route-table-ids <TOKYO_PRIVATE_RTB_ID> \
  --query 'RouteTables[0].Routes[*].[DestinationCidrBlock,TransitGatewayId,State]' \
  --output table

aws ec2 describe-route-tables \
  --region sa-east-1 \
  --route-table-ids <SAOPAULO_PRIVATE_RTB_ID> \
  --query 'RouteTables[0].Routes[*].[DestinationCidrBlock,TransitGatewayId,State]' \
  --output table


########################################################################################

Data-plane proof (Lab1c-style, optional but best)

From São Paulo client (SSM session), test connectivity to Tokyo DB port:

nc -vz <tokyo-rds-endpoint> 3306
# or 5432 for postgres
