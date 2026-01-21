db_secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:lab/db/mysql-abc1


✅ REQUIRED SCREENSHOTS — Bonus-A (Lab1C)
1️⃣ EC2 Instance is PRIVATE (no public IP)

Where:

AWS Console → EC2 → Instances → your Bonus-A EC2

Screenshot must show:

Instance details page

Public IPv4 address = “–” (blank)

Subnet = private subnet

📸 Filename suggestion

01-ec2-private-no-public-ip.png


🧠 What this proves

Compute is not internet-exposed (core Bonus-A requirement)

2️⃣ SSM Session Manager works (NO SSH)

Where:

AWS Console → Systems Manager → Session Manager

Start a session to your EC2 instance

Screenshot must show:

Active terminal session

Instance ID visible in the header

📸 Filename

02-ssm-session-manager-connected.png


🧠 What this proves

Management access works without SSH or public IP

3️⃣ Managed Instance registered in SSM

Where:

Systems Manager → Fleet Manager (or Managed instances)

Screenshot must show:

Your EC2 instance listed

Status = Online

📸 Filename

03-ssm-managed-instance-online.png


🧠 What this proves

IAM role + SSM endpoints are correctly configured

4️⃣ VPC Endpoints exist (Interface + Gateway)

Where:

VPC → Endpoints

You can do ONE screenshot if everything is visible, or two if needed.

Must show endpoints for:

ssm

ec2messages

ssmmessages

logs

secretsmanager

s3 (Gateway)

📸 Filename

04-vpc-endpoints-bonus-a.png


🧠 What this proves

Private connectivity to AWS services (no NAT / no IGW dependency)

5️⃣ Interface Endpoint Security Group allows 443 from EC2 SG

Where:

VPC → Security Groups → VPCE SG

Screenshot must show:

Inbound rule:

TCP 443

Source = EC2 security group

📸 Filename

05-vpce-security-group-https.png


🧠 What this proves

Endpoint traffic is intentionally scoped (least privilege)

6️⃣ Terraform outputs (Bonus-A proof)

Where:

Terminal after terraform apply

OR terraform output

Must show outputs like:

bonus_a_vpce_ssm_id

bonus_a_vpce_logs_id

bonus_a_vpce_secrets_id

bonus_a_vpce_s3_id

bonus_a_private_ec2_instance_id

📸 Filename

06-terraform-outputs-bonus-a.png


🧠 What this proves

Infrastructure-as-code evidence (very important for grading)

⭐ OPTIONAL (extra credit / polish)
7️⃣ Parameter Store values exist

Where:

Systems Manager → Parameter Store

Show:

/lab/db/endpoint

/lab/db/port

📸

optional-parameter-store-db-values.png

8️⃣ CloudWatch Log Group exists

Where:

CloudWatch → Log groups

Show:

Your app log group name

Recent log streams

📸

optional-cloudwatch-log-group.png

🚫 Screenshots you do NOT need

❌ Terraform files in VS Code
❌ IAM JSON policy bodies
❌ Route tables (unless instructor explicitly asks)
❌ NAT Gateway (Bonus-A intentionally avoids it)

🧾 Final checklist (copy into README.md)
## Bonus-A Verification Evidence

- [x] EC2 instance has no public IP
- [x] SSM Session Manager access confirmed
- [x] Instance registered as SSM managed
- [x] VPC Interface & Gateway endpoints present
- [x] Endpoint SG restricts HTTPS to EC2 SG
- [x] Terraform outputs captured
