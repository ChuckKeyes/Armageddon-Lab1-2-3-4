0) Design rules (so the requirement is actually enforced)

You enforce this in two places:

IAM (who can read)

São Paulo EC2 assumes an IAM role with S3 GetObject only to a Tokyo bucket + prefix.

If the medical files are encrypted with KMS: allow kms:Decrypt only for that key.

S3 Bucket Policy (what is allowed / denied)

Tokyo bucket policy allows reads only from that São Paulo role and only for the “medical/” prefix.

Optional hardening: require requests come via a VPC endpoint (aws:sourceVpce) and/or TLS.

TGW is for private network connectivity, but access control for “only read medical files” should be enforced by IAM + bucket policy (that’s the real lock).

1) Root / Main (the “orchestrator”)

Purpose: provider aliases, remote-state wiring, module calls in the right order.

Files

providers.tf

aws default (Tokyo)

aws.saopaulo alias (São Paulo)

backend.tf (state)

variables.tf (global knobs)

main.tf (calls modules)

outputs.tf (surface key outputs)

Root main.tf flow (high level)

module "tokyo_medical"

module "tgw_core" (or tgw in tokyo module if you want it tightly coupled)

module "saopaulo_compute" (consumes outputs from tokyo/tgw)

Root uses:

data.terraform_remote_state.tokyo if you keep Tokyo separate

OR direct module.tokyo_medical.outputs if it’s the same root

2) Module: Tokyo Medical (authority side)

Purpose: everything “medical” lives here.

Tokyo module contains

A) Network (Tokyo VPC)

VPC + subnets (private/public as needed)

route tables, NACLs (optional)

security groups

B) Medical Data Store (S3)

aws_s3_bucket tokyo_medical_bucket

aws_s3_bucket_public_access_block

aws_s3_bucket_versioning (recommended)

aws_s3_bucket_server_side_encryption_configuration

KMS key if required for compliance

C) Optional: DB / App (if this is part of Tokyo medical center)

RDS in private subnets

SG rules limited to app tier

D) Access control outputs (critical)

Tokyo module must output:

tokyo_medical_bucket_arn

tokyo_medical_bucket_name

tokyo_medical_prefix (ex: "medical/")

tokyo_kms_key_arn (if used)

Tokyo bucket policy should reference the São Paulo IAM role ARN (passed in from root or added later).

3) Module: TGW Core (private connectivity layer)

Purpose: private routing between Tokyo and São Paulo VPCs (if your lab requires it).

Minimum TGW components

A) Tokyo TGW

aws_ec2_transit_gateway tokyo_tgw

aws_ec2_transit_gateway_vpc_attachment tokyo_attach

TGW route tables + associations/propagation

B) São Paulo TGW (needed for inter-region peering)

aws_ec2_transit_gateway saopaulo_tgw

aws_ec2_transit_gateway_vpc_attachment saopaulo_attach

C) TGW Peering (Tokyo <-> São Paulo)

aws_ec2_transit_gateway_peering_attachment

accepter in the other region/provider alias

TGW routes:

Tokyo routes to São Paulo CIDR via peering

São Paulo routes to Tokyo CIDR via peering

TGW outputs

tokyo_tgw_id, tokyo_tgw_rt_id

saopaulo_tgw_id, saopaulo_tgw_rt_id

tgw_peering_attachment_id

Important: TGW enables private IP routing, but it does not “grant permission” to read S3 objects. That’s IAM/S3 policy.

4) Module: São Paulo Compute (consumer side)

Purpose: EC2 (or autoscaling) that can only read the Tokyo medical files.

São Paulo module contains

A) Network (São Paulo VPC)

VPC + private subnets

route tables

attach to TGW (if using TGW module outputs)

B) Compute

EC2 instances (private)

SG (egress locked down if you want)

SSM endpoints (optional)

C) IAM Role (the “only read medical files” lock)

Create an instance role with a policy like:

Allow:

s3:GetObject on arn:aws:s3:::<tokyo-bucket>/medical/*

s3:ListBucket but only with prefix condition medical/

If KMS: kms:Decrypt for Tokyo key only

D) Inputs São Paulo must receive

tokyo_medical_bucket_name (or ARN)

tokyo_medical_prefix (medical/)

tokyo_kms_key_arn (if needed)

(optional) tokyo_bucket_vpce_id if you enforce endpoint-only access

Outputs São Paulo should provide back

saopaulo_medical_reader_role_arn ✅ (Tokyo uses this in bucket policy)

instance IDs / private IPs

5) The “Only Read Medical Files” enforcement wiring

This is the part that makes your requirement real:

Step 1 — São Paulo module outputs the role ARN

saopaulo_medical_reader_role_arn

Step 2 — Tokyo module creates bucket policy allowing ONLY that role

Tokyo bucket policy logic:

Allow s3:GetObject only for:

Principal = São Paulo role ARN

Resource = bucket-arn/medical/*

Allow s3:ListBucket only with prefix = medical/

Explicit deny everything else (optional but strong)

6) Suggested folder layout (simple + scalable)

root/
  main.tf
  providers.tf
  variables.tf
  outputs.tf
  backend.tf

  modules/
    tokyo_medical/
      main.tf
      variables.tf
      outputs.tf
      network.tf
      s3_medical.tf
      kms.tf
      rds.tf   (optional)
      policy_bucket.tf

    tgw_core/
      main.tf
      variables.tf
      outputs.tf
      tokyo_tgw.tf
      saopaulo_tgw.tf
      peering.tf
      routes.tf

    saopaulo_compute/
      main.tf
      variables.tf
      outputs.tf
      network.tf
      compute.tf
      iam_medical_reader.tf
      sg.tf
