
## 0) Set your variables (do this first)

`REGION=us-east-1`  
`ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)`  
`VPC_ID=vpc-10.10.0.0/24  
`PUBLIC_SUBNET_ID=subnet-10.10.1.0/24  
`PRIVATE_SUBNET_A=subnet-10.10.10.0/16  
`PRIVATE_SUBNET_B=subnet-10.10.11.0/16`  
`EC2_SG_NAME=sg-ec2-lab`  
`RDS_SG_NAME=sg-rds-lab`  
`DB_ID=lab-mysql`  
`DB_USER=admin`  
`DB_PASS='Nicholas111317!'`  
`SECRET_ID=lab/rds/mysql`  
`ROLE_NAME=lab-ec2-secrets-role`  
`PROFILE_NAME=lab-ec2-instance-profile`

---

## 1) Networking + Security Groups (missing “create” steps)

**`EC2_SG_ID=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC_ID" --group-name "$EC2_SG_NAME" --description "EC2 lab SG" --query GroupId --output text)`**

**`aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$EC2_SG_ID" --ip-permissions '[ {"IpProtocol":"tcp","FromPort":80,"ToPort":80,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]} ]'`**

(Optional SSH from your IP)  
**`MYIP=$(curl -s ifconfig.me)/32`**  
**`aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$EC2_SG_ID" --protocol tcp --port 22 --cidr "$MYIP"`**

**`RDS_SG_ID=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC_ID" --group-name "$RDS_SG_NAME" --description "RDS lab SG" --query GroupId --output text)`**

**`aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$RDS_SG_ID" --ip-permissions "[ {\"IpProtocol\":\"tcp\",\"FromPort\":3306,\"ToPort\":3306,\"UserIdGroupPairs\":[{\"GroupId\":\"$EC2_SG_ID\"}]} ]"`**

This matches the lab’s required SG-to-SG trust pattern.

---

## 2) RDS Subnet Group + RDS instance (missing “create” steps)

**`aws rds create-db-subnet-group --region "$REGION" --db-subnet-group-name lab-private-dbsubnets --db-subnet-group-description "Private subnets for lab RDS" --subnet-ids "$PRIVATE_SUBNET_A" "$PRIVATE_SUBNET_B"`**

**`aws rds create-db-instance --region "$REGION" \ --db-instance-identifier "$DB_ID" \ --engine mysql \ --db-instance-class db.t3.micro \ --allocated-storage 20 \ --master-username "$DB_USER" \ --master-user-password "$DB_PASS" \ --vpc-security-group-ids "$RDS_SG_ID" \ --db-subnet-group-name lab-private-dbsubnets \ --no-publicly-accessible`**

Wait until it’s ready:  
**`aws rds wait db-instance-available --region "$REGION" --db-instance-identifier "$DB_ID"`**

---

## 3) Secrets Manager secret (missing “create” step)

Get the DB endpoint:  
**`DB_ENDPOINT=$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query "DBInstances[0].Endpoint.Address" --output text)`**

Create the secret in the format the app expects (username/password/host/port/dbname). This aligns with your user-data app.

**`aws secretsmanager create-secret --region "$REGION" --name "$SECRET_ID" --secret-string "{ \"username\":\"$DB_USER\", \"password\":\"$DB_PASS\", \"host\":\"$DB_ENDPOINT\", \"port\":3306, \"dbname\":\"labdb\" }"`**

---

## 4) IAM Role + inline policy + instance profile (missing “create” steps)

Create trust policy (EC2 can assume role):  
**`cat > /tmp/trust.json <<'JSON' { "Version": "2012-10-17", "Statement": [{ "Effect": "Allow", "Principal": { "Service": "ec2.amazonaws.com" }, "Action": "sts:AssumeRole" }] } JSON`**

**`aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file:///tmp/trust.json`**

Create inline permissions policy (least privilege to that one secret). This matches your provided example shape.

1a_inline_policy

**`cat > /tmp/inline_policy.json <<JSON { "Version": "2012-10-17", "Statement": [{ "Sid": "ReadSpecificSecret", "Effect": "Allow", "Action": ["secretsmanager:GetSecretValue"], "Resource": "arn:aws:secretsmanager:$REGION:$ACCOUNT_ID:secret:$SECRET_ID*" }] } JSON`**

**`aws iam put-role-policy --role-name "$ROLE_NAME" --policy-name lab-read-secret-inline --policy-document file:///tmp/inline_policy.json`**

Create + attach instance profile:  
**`aws iam create-instance-profile --instance-profile-name "$PROFILE_NAME"`**  
**`aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE_NAME" --role-name "$ROLE_NAME"`**

---

## 5) Launch EC2 with user-data (missing “create” step)

Save your provided user data script locally as `1a_user_data.sh` (you already have it).

1a_user_data

Then launch EC2 (replace AMI + key name if needed):

**`AMI_ID=ami-xxxxxxxx`**  
**`KEY_NAME=your-keypair-name`**

**`INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" \ --image-id "$AMI_ID" \ --instance-type t3.micro \ --key-name "$KEY_NAME" \ --subnet-id "$PUBLIC_SUBNET_ID" \ --security-group-ids "$EC2_SG_ID" \ --iam-instance-profile Name="$PROFILE_NAME" \ --user-data file://1a_user_data.sh \ --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=lab-ec2-app}]" \ --query "Instances[0].InstanceId" --output text)`**

Wait for running:  
**`aws ec2 wait instance-running --region "$REGION" --instance-ids "$INSTANCE_ID"`**

Get public IP:  
**`EC2_IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)`**  
`echo "EC2 IP: $EC2_IP"`

---

## 6) App test (browser)

Open:

- `http://$EC2_IP/init`
    
- `http://$EC2_IP/add?note=first_note`
    
- `http://$EC2_IP/list`
    

These are the exact endpoints in your user-data app.

1a_user_data

---

## 7) Keep your existing PASS/FAIL checks (as-is)

These are already in your troubleshooting/check guidance:

From workstation:  
`aws secretsmanager describe-secret --secret-id "$SECRET_ID" --region "$REGION" >/dev/null && echo PASS || echo FAIL`

`aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --region "$REGION" --query "Reservations[0].Instances[0].IamInstanceProfile.Arn" --output text`

`aws rds describe-db-instances --db-instance-identifier "$DB_ID" --region "$REGION" --query "DBInstances[0].PubliclyAccessible" --output text`

If you’re using the gate scripts, your final check expects:

- `gate_secrets_and_role.sh`
    
- `gate_network_db.sh`
    
- `run_all_gates.sh`  
    
    1a_final_check
    

---

If you want, paste your **actual VPC/subnet IDs + AMI ID**,