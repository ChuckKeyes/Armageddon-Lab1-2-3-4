1) Lab3 ROOT (main.tf / root folder)

Root = orchestration + cross-region wiring

Providers

provider aws default (optional)

provider aws { alias = "tokyo" region = "ap-northeast-1" }

provider aws { alias = "saopaulo" region = "sa-east-1" }

Module calls

module "tokyo" (providers = aws.tokyo)

module "saopaulo_compute" (providers = aws.saopaulo)

Cross-region TGW peering (must be root)

aws_ec2_transit_gateway_peering_attachment (Tokyo requester)

aws_ec2_transit_gateway_peering_attachment_accepter (São Paulo accepter)

Cross-region TGW routes (must be root)

Tokyo TGW route table: 10.20.0.0/16 -> peering attachment

São Paulo TGW route table: 10.10.0.0/16 -> peering attachment

Cross-region VPC route table routes (can be root)

Tokyo private RT: 10.20.0.0/16 -> Tokyo TGW

São Paulo private RT: 10.10.0.0/16 -> São Paulo TGW

Policy/controls (read-only) wiring (root or Tokyo module, your choice)

Root is fine if it references both modules. Cleanest is Tokyo module (see below).

Root variables (inputs only)

project_name, tags, environment

tokyo_vpc_cidr (10.10.0.0/16)

saopaulo_vpc_cidr (10.20.0.0/16) (or passed into module)

feature flags (enable_peering, enable_readonly, etc.)

Root outputs (high value)

TGW IDs, peering attachment id

VPC IDs, CIDRs

private subnet ids

private route table ids

(later) EC2 private IPs for testing

2) modules/tokyo_authority (Tokyo “main” inside the module)

Tokyo module = medical authority (data owner)

Tokyo networking

Tokyo VPC + subnets + route tables

Tokyo IGW/NAT/endpoints (only if you need)

Tokyo security groups

Tokyo TGW (lives here)

aws_ec2_transit_gateway (Tokyo)

aws_ec2_transit_gateway_vpc_attachment (Tokyo VPC -> Tokyo TGW)

Tokyo medical data layer (lives here)

Choose one:

RDS (recommended for lab story)

DB subnet group

RDS instance

DB SG (DB port inbound limited)

Secret(s) in Secrets Manager

or S3 bucket “medical-records”

Read-only enforcement (should live here)

Because Tokyo owns the data, Tokyo should enforce:

DB SG: allow DB port from São Paulo CIDR (10.20.0.0/16)

DB permissions: create medical_ro user (select only)

Secrets Manager: store RO creds as separate secret (tokyo/medical_ro)

Tokyo outputs (export only what root needs)

tokyo_vpc_id, tokyo_vpc_cidr

tokyo_private_subnet_ids

tokyo_private_route_table_ids

tokyo_tgw_id

tokyo_tgw_vpc_attachment_id

(if needed) tokyo_db_sg_id, tokyo_db_endpoint, tokyo_medical_ro_secret_arn

3) modules/saopaulo_compute (São Paulo “main” inside the module)

São Paulo module = compute consumer (read-only client)

São Paulo networking

Liberdade VPC + 2 private subnets + private route table

SGs for EC2/clients

São Paulo TGW (lives here)

aws_ec2_transit_gateway (São Paulo)

aws_ec2_transit_gateway_vpc_attachment (Liberdade VPC -> São Paulo TGW)

São Paulo compute (optional / for proof)

1 EC2 “client” (or ASG later)

IAM role that can read only the RO secret (if you’re using RDS)

SSM access if you want private management

São Paulo outputs

saopaulo_vpc_id, saopaulo_vpc_cidr

saopaulo_private_subnet_ids

saopaulo_private_route_table_id

saopaulo_tgw_id

saopaulo_tgw_vpc_attachment_id

(later) client instance private IP

Quick rule: what MUST be root vs module

✅ Must be ROOT

TGW peering (attachment + accepter)

any resource that references both regions/modules

✅ Belongs in Tokyo module

medical DB/S3

read-only enforcement (DB user, SG inbound, secret)

✅ Belongs in São Paulo module

“client” compute + its IAM

anything only in sa-east-1