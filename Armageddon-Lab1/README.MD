kcs-lab/
├─ modules/
│  ├─ network/        # VPC, IGW, subnets, NAT, route tables
│  ├─ security/       # SGs (EC2 + RDS) + rules
│  ├─ iam/            # EC2 role + attachments + instance profile
│  ├─ rds/            # db subnet group + db instance
│  ├─ compute/        # EC2 instance (app host)
│  ├─ config/         # SSM parameters + Secrets Manager secret/version
│  ├─ observability/  # log group + cloudwatch alarm
│  └─ notifications/  # SNS topic + email subscription
└─ stages/
   ├─ 01-network/
   ├─ 02-security/
   ├─ 03-iam/
   ├─ 04-rds/
   ├─ 05-compute/
   ├─ 06-config/
   ├─ 07-observability/
   └─ 08-notifications/

terraform_remote_state


2) Module contracts (what each module should output)
modules/network (VPC + IGW + subnets + NAT + routes)

Inputs

project_name, vpc_cidr, public_subnet_cidrs, private_subnet_cidrs, azs

Outputs

vpc_id

public_subnet_ids

private_subnet_ids

igw_id

nat_gateway_id

modules/security (EC2 SG + RDS SG + rules)

Inputs

project_name, vpc_id, db_port, my_ip_cidr (optional)
Outputs

ec2_sg_id

rds_sg_id

modules/iam (role + instance profile)

Inputs

project_name
Outputs

instance_profile_name

role_name

modules/rds (subnet group + db)

Inputs

project_name, private_subnet_ids, rds_sg_id,

db_engine, db_instance_class, db_name, db_username, db_password
Outputs

db_endpoint

db_port

db_identifier

modules/compute (EC2)

Inputs

project_name, ami, instance_type, public_subnet_id, ec2_sg_id

instance_profile_name (optional)
Outputs

instance_id

public_ip

public_dns

modules/config (SSM + Secrets)

Inputs

project_name, db_endpoint, db_port, db_name, db_username, db_password
Outputs

ssm_endpoint_param_name, ssm_port_param_name, ssm_dbname_param_name

secret_arn

modules/notifications (SNS)

Inputs

project_name, sns_email_endpoint
Outputs

sns_topic_arn

modules/observability (logs + alarm)

Inputs

project_name, sns_topic_arn
Outputs

log_group_name

alarm_name


kcs-lab/
├─ modules/
│  ├─ network/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  ├─ security/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  ├─ iam/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  ├─ rds/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  ├─ compute/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  ├─ config/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  ├─ notifications/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  └─ observability/
│     ├─ main.tf
│     ├─ variables.tf
│     └─ outputs.tf
└─ stages/
   ├─ 01-network/
   │  ├─ main.tf
   │  └─ variables.tf
   ├─ 02-security/
   │  ├─ main.tf
   │  └─ variables.tf
   ├─ 03-iam/
   │  ├─ main.tf
   │  └─ variables.tf
   ├─ 04-rds/
   │  ├─ main.tf
   │  └─ variables.tf
   ├─ 05-compute/
   │  ├─ main.tf
   │  └─ variables.tf
   ├─ 06-config/
   │  ├─ main.tf
   │  └─ variables.tf
   ├─ 07-notifications/
   │  ├─ main.tf
   │  └─ variables.tf
   └─ 08-observability/
      ├─ main.tf
      └─ variables.tf
https://557690581423.signin.aws.amazon.com/console
<YOUR_OLD_ACCESS_KEY_ID>==>REDACTED_AWS_ACCESS_KEY_ID
<YOUR_OLD_SECRET_ACCESS_KEY>==>REDACTED_AWS_SECRET_ACCESS_KEY


3️⃣ Pro-level improvements (optional but recommended)
A) Stop before SNS (email confirmation)

If you want to pause before notifications, split runs:

./apply-all.sh | tee apply.log


Or temporarily comment out:

"07-notifications"
"08-observability"

B) Dry-run mode (plan only)

Create a plan-only runner:

sed 's/apply -auto-approve/plan/' apply-all.sh > plan-all.sh
chmod +x plan-all.sh

C) Stage-by-stage runner

Run just one stage:

cd stages/04-rds
terraform init && terraform apply

4️⃣ Why this is recruiter-grade

This runner demonstrates:

✅ Deterministic IaC execution

✅ Dependency-aware ordering

✅ Fail-fast behavior

✅ Clean separation of concerns

✅ Production-style orchestration (without Terraform Cloud)

This is exactly how senior engineers manage complex Terraform stacks.

################################################################################

cd stages/1-network
terraform init && terraform apply

