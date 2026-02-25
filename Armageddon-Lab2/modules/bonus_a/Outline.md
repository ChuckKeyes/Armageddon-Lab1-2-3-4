1) Add the two data sources + locals (safe)

Create bonus-a-data.tf:

data "aws_caller_identity" "self" {}

data "aws_region" "current" {}

Then locals:

local.prefix = var.project_name

secret ARN guess (works, but best practice is step 7)

✅ This part can be added immediately.

2) Create a dedicated SG for VPC endpoints (Interface endpoints)

Create bonus-a-vpce-sg.tf:

Inbound rule needed:

TCP 443 from your EC2 SG (best) or from VPC CIDR (simpler)

Example logic (conceptually):

vpce_sg ingress 443 source_security_group_id = ec2_sg.id

Why: interface endpoints receive HTTPS traffic from your instance.

3) Add the VPC endpoints

Create bonus-a-endpoints.tf:

A) S3 Gateway endpoint

Needs vpc_id

Needs private route table IDs (the RT associated with your private subnets)

B) Interface endpoints

Put them in private subnets:

subnet_ids = aws_subnet.<private>[*].id

security_group_ids = [aws_security_group.<vpce_sg>.id]

private_dns_enabled = true

Add these services:

ssm

ec2messages

ssmmessages

logs

secretsmanager

(optional) kms

✅ After this, your private EC2 can talk to AWS APIs privately.

4) Move EC2 to private subnet + remove public exposure

You will do ONE of these:

Option A (recommended): modify existing app instance

Change:

subnet_id = aws_subnet.<private>[0].id

Ensure:

associate_public_ip_address = false (or just rely on private subnet behavior)

Remove / disable SSH inbound rules (or leave temporarily while testing)

Option B: Create a “bonus” second EC2

That’s what your snippet does.

Works, but you must avoid duplicates:

different resource name

different Name tag

✅ Result: no public IP, access via SSM.

5) Ensure IAM role for EC2 includes SSM core permissions

Your EC2 role must have:

AmazonSSMManagedInstanceCore

If Lab1C already has it, great.
If not, attach it.

This is required before Session Manager works.

6) Add least-privilege IAM policies (Bonus-A)

Create bonus-a-iam.tf and add:

Read Parameter Store path /lab/db/*

Read secret (temporary guess ARN OR real ARN)

Write CloudWatch Logs to your app log group ARN

Then attach those policies to the same EC2 role your instance uses.

7) Fix the “secret ARN guess” the right way (after first apply)

Your snippet uses:

local.secret_arn_guess = arn:aws:secretsmanager:region:acct:secret:${prefix}/rds/mysql*

That’s ok for “lab mode”, but can break if the secret name differs.

Better approach:

Output the secret ARN from the resource that creates it (or data-source it)

Then set local.secret_arn to the real one

So:

terraform apply

copy the real secret ARN from outputs/state

replace the wildcard guess with the exact ARN

terraform apply again

8) Test checklist (Bonus-A proof)

After apply, verify:

A) Instance is PRIVATE

EC2 has no public IPv4

B) SSM session works

AWS Console → Systems Manager → Fleet Manager / Managed instances

Start Session Manager session

C) Endpoints exist

VPC → Endpoints shows:

Gateway: S3

Interface: ssm/ec2messages/ssmmessages/logs/secretsmanager/(kms)

D) App can read:

SSM params: /lab/db/endpoint and /lab/db/port

Secret value (if you configured that)

The 3 “gotchas” that break Bonus-A every time

Interface endpoint SG missing inbound 443

Must allow 443 from EC2 SG (or VPC CIDR)

EC2 role missing AmazonSSMManagedInstanceCore

SSM won’t register the instance

No NAT + you try yum/apt updates

Endpoints cover AWS APIs, not the public internet

If your user_data installs packages, it may fail unless NAT exists (or you handle it differently)