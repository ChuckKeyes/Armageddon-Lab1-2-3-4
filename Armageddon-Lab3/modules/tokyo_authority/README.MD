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
