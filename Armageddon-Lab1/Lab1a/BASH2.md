

0) Prereqs (one-time)

1) aws --version
aws sts get-caller-identity

### If either fails, fix AWS CLI config first (`aws configure`, correct profile, etc.).

## 1) Set variables (EDIT THESE)

> **You must paste real IDs** for your VPC + subnets + key pair.  
> RDS needs **two private subnets in different AZs**.

# ---- REQUIRED: set these ----
export REGION="ap-northeast-1"

export VPC_ID="vpc-vpc-0f788f9702ce28e45"
export PUBLIC_SUBNET_ID="subnet-10.10.0.0/16"     # EC2 public subnet
export PRIVATE_SUBNET_A="subnet-10.10.10.0/24"     # RDS private subnet A (AZ1)
export PRIVATE_SUBNET_B="subnet-10.10.11.0/24"     # RDS private subnet B (AZ2)

export KEY_NAME="japan-keypair"                   # only needed if you want SSH
# Amazon Linux 2023 AMI (you can auto-discover below)

# ---- lab naming (keep as-is unless your class requires different) ----
export EC2_SG_NAME="sg-ec2-lab"
export RDS_SG_NAME="sg-rds-lab"
export DB_ID="lab-mysql"
export DB_USER="admin"
export DB_PASS='Nicholas111317!'                      # set your own if required
export SECRET_ID="lab/rds/mysql"
export ROLE_NAME="lab-ec2-secrets-role"
export PROFILE_NAME="lab-ec2-instance-profile"
export DB_SUBNET_GROUP="lab-private-dbsubnets"

### Optional: auto-pick latest Amazon Linux 2023 AMI in your region:

export AMI_ID="$(aws ssm get-parameter \
  --region "$REGION" \
  --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query 'Parameter.Value' --output text)"
echo "AMI_ID=$AMI_ID"
#####################################################################

export REGION="ap-northeast-1"
export AWS_REGION="$REGION"
export AWS_DEFAULT_REGION="$REGION"

export AMI_ID="$(aws ec2 describe-images \
  --region "$REGION" \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" \
  --query "Images | sort_by(@,&CreationDate)[-1].ImageId" \
  --output text)"

echo "AMI_ID=$AMI_ID"
#### AMI_ID=ami-06f5894a96560ed52
export AMI_ID="ami-06f5894a96560ed52"
## aws configure set region ap-northeast-1



######################################################################
## 2) Create Security Groups (EC2 + RDS) + rules

### 2.1 Create EC2 SG + allow HTTP (and optional SSH from your IP)
export EC2_SG_NAME="ec2-lab-sg"
echo "EC2_SG_NAME=$EC2_SG_NAME"
export EC2_SG_ID="$(aws ec2 create-security-group \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --group-name "$EC2_SG_NAME" \
  --description "EC2 lab SG" \
  --query GroupId --output text)"

echo "EC2_SG_ID=$EC2_SG_ID"
====> EC2_SG_ID=sg-0f932af801e33d267


aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$EC2_SG_ID" \
  --ip-permissions '[{"IpProtocol":"tcp","FromPort":80,"ToPort":80,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}]'
##########################################################################

  "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0a473d6c968b4d634",
            "GroupId": "sg-0f932af801e33d267",
            "GroupOwnerId": "557690581423",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIpv4": "0.0.0.0/0",
            "SecurityGroupRuleArn": "arn:aws:ec2:ap-northeast-1:557690581423:security-group-rule/sgr-0a473d6c968b4d634"
        }
    # Show the RDS security group rules (TABLE format)
    aws ec2 describe-security-groups \
  --region "$REGION" \
  --group-ids "$RDS_SG_ID" \
  --query "SecurityGroups[0].IpPermissions" \
  --output table
  --output table
--------------------------------------------
|          DescribeSecurityGroups          |
+-------------+----------------+-----------+
|  FromPort   |  IpProtocol    |  ToPort   |
+-------------+----------------+-----------+
|  3306       |  tcp           |  3306     |
+-------------+----------------+-----------+
||            UserIdGroupPairs            ||
|+-----------------------+----------------+|
||        GroupId        |    UserId      ||
|+-----------------------+----------------+|
||  sg-0f932af801e33d267 |  557690581423  ||
|+-----------------------+----------------+|

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws ec2 describe-security-groups \
  --region "$REGION" \
  --group-ids "$EC2_SG_ID" "$RDS_SG_ID" \
  --query "SecurityGroups[].{GroupId:GroupId,Ingress:IpPermissions}" \
  --output table
----------------------------------------------
|           DescribeSecurityGroups           |
+--------------------------------------------+
|                   GroupId                  |
+--------------------------------------------+
|  sg-001b40d6a6334fb9d                      |
+--------------------------------------------+
||                  Ingress                 ||
|+-------------+----------------+-----------+|
||  FromPort   |  IpProtocol    |  ToPort   ||
|+-------------+----------------+-----------+|
||  3306       |  tcp           |  3306     ||
|+-------------+----------------+-----------+|
|||            UserIdGroupPairs            |||
||+-----------------------+----------------+||
|||        GroupId        |    UserId      |||
||+-----------------------+----------------+||
|||  sg-0f932af801e33d267 |  557690581423  |||
||+-----------------------+----------------+||
|           DescribeSecurityGroups           |
+--------------------------------------------+
|                   GroupId                  |
+--------------------------------------------+
|  sg-0f932af801e33d267                      |
+--------------------------------------------+
||                  Ingress                 ||
|+-------------+----------------+-----------+|
||  FromPort   |  IpProtocol    |  ToPort   ||
|+-------------+----------------+-----------+|
||  80         |  tcp           |  80       ||
|+-------------+----------------+-----------+|
|||                IpRanges                |||
||+----------------------------------------+||
|||                 CidrIp                 |||
||+----------------------------------------+||
|||  0.0.0.0/0                             |||
||+----------------------------------------+||


##########################################################################
### Optional SSH (recommended if you’ll debug):

MYIP="$(curl -s ifconfig.me)/32"
aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$EC2_SG_ID" \
  --protocol tcp --port 22 --cidr "$MYIP"

### 2.2 Create RDS SG + allow 3306 **ONLY from EC2 SG**

export RDS_SG_ID="$(aws ec2 create-security-group \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --group-name "$RDS_SG_NAME" \
  --description "RDS lab SG" \
  --query GroupId --output text)"

echo "RDS_SG_ID=$RDS_SG_ID"
#########################################################################

export RDS_SG_NAME="rds-lab-sg"
echo "RDS_SG_NAME=$RDS_SG_NAME"

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ export RDS_SG_ID="$(aws ec2 create-security-group \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --group-name "$RDS_SG_NAME" \
  --description "RDS lab SG" \
  --query GroupId --output text)"

echo "RDS_SG_ID=$RDS_SG_ID"
RDS_SG_ID=sg-001b40d6a6334fb9d

########################################################################
aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$RDS_SG_ID" \
  --ip-permissions "[{\"IpProtocol\":\"tcp\",\"FromPort\":3306,\"ToPort\":3306,\"UserIdGroupPairs\":[{\"GroupId\":\"$EC2_SG_ID\"}]}]"
  #######################################################################
aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$RDS_SG_ID" \
  --ip-permissions "[{\"IpProtocol\":\"tcp\",\"FromPort\":3306,\"ToPort\":3306,\"UserIdGroupPairs\":[{\"GroupId\":\"$EC2_SG_ID\"}]}]"
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-066a024aa69edcd47",
            "GroupId": "sg-001b40d6a6334fb9d",
            "GroupOwnerId": "557690581423",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 3306,
            "ToPort": 3306,
            "ReferencedGroupInfo": {
                "GroupId": "sg-0f932af801e33d267",
                "UserId": "557690581423"
            },
            "SecurityGroupRuleArn": "arn:aws:ec2:ap-northeast-1:557690581423:security-group-rule/sgr-066a024aa69edcd47"
        }
    ]
}
# check
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws ec2 describe-security-groups \
  --region "$REGION" \
  --group-ids "$RDS_SG_ID" \
  --query "SecurityGroups[0].IpPermissions" \
  --output table
--------------------------------------------
|          DescribeSecurityGroups          |
+-------------+----------------+-----------+
|  FromPort   |  IpProtocol    |  ToPort   |
+-------------+----------------+-----------+
|  3306       |  tcp           |  3306     |
+-------------+----------------+-----------+
||            UserIdGroupPairs            ||
|+-----------------------+----------------+|
||        GroupId        |    UserId      ||
|+-----------------------+----------------+|
||  sg-0f932af801e33d267 |  557690581423  ||
|+-----------------------+----------------+|

##########################################################################
### Create two PRIVATE subnets IN VPC
These CIDRs are valid inside `10.10.0.0/16`:

export AZ1="ap-northeast-1a"
export AZ2="ap-northeast-1c"

export PRIVATE_SUBNET_1="$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --availability-zone "$AZ1" \
  --cidr-block "10.10.1.0/24" \
  --query "Subnet.SubnetId" --output text)"

export PRIVATE_SUBNET_2="$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --availability-zone "$AZ2" \
  --cidr-block "10.10.2.0/24" \
  --query "Subnet.SubnetId" --output text)"

echo "PRIVATE_SUBNET_1=$PRIVATE_SUBNET_1"
echo "PRIVATE_SUBNET_2=$PRIVATE_SUBNET_2"
##########################################################################
### Proof
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws ec2 describe-subnets \
  --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[].{SubnetId:SubnetId,AZ:AvailabilityZone,CIDR:CidrBlock,PublicIP:MapPublicIpOnLaunch}" \
  --output table
-----------------------------------------------------------------------------
|                              DescribeSubnets                              |
+------------------+---------------+-----------+----------------------------+
|        AZ        |     CIDR      | PublicIP  |         SubnetId           |
+------------------+---------------+-----------+----------------------------+
|  ap-northeast-1a |  10.10.1.0/24 |  False    |  subnet-06b798d37bd4d2613  |
|  ap-northeast-1c |  10.10.2.0/24 |  False    |  subnet-023129f92a48faa7e  |
+------------------+---------------+-----------+----------------------------+
### TAGS

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws ec2 describe-subnets \
  --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[].{SubnetId:SubnetId,Name:Tags[?Key=='Name']|[0].Value,AZ:AvailabilityZone,CIDR:CidrBlock}" \
  --output table
  
----------------------------------------------------------------------------------
|                                 DescribeSubnets                                |
+-----------------+---------------+----------------+-----------------------------+
|       AZ        |     CIDR      |     Name       |          SubnetId           |
+-----------------+---------------+----------------+-----------------------------+
|  ap-northeast-1a|  10.10.1.0/24 |  lab-private-1 |  subnet-06b798d37bd4d2613   |
|  ap-northeast-1c|  10.10.2.0/24 |  lab-private-2 |  subnet-023129f92a48faa7e   |
+-----------------+---------------+----------------+-----------------------------+
### Export the two private subnet IDs
export PRIVATE_SUBNET_1="subnet-06b798d37bd4d2613"
export PRIVATE_SUBNET_2="subnet-023129f92a48faa7e"

echo "PRIVATE_SUBNET_1=$PRIVATE_SUBNET_1"
echo "PRIVATE_SUBNET_2=$PRIVATE_SUBNET_2"

### Create the DB subnet group (lab-private-dbsubnets)

aws rds create-db-subnet-group \
  --region "$REGION" \
  --db-subnet-group-name "$DB_SUBNET_GROUP" \
  --db-subnet-group-description "Lab1a private DB subnet group" \
  --subnet-ids "$PRIVATE_SUBNET_1" "$PRIVATE_SUBNET_2"
####################################
{
    "DBSubnetGroup": {
        "DBSubnetGroupName": "lab-private-dbsubnets",
        "DBSubnetGroupDescription": "Lab1a private DB subnet group",
        "VpcId": "vpc-0f788f9702ce28e45",
        "SubnetGroupStatus": "Complete",
        "Subnets": [
            {
                "SubnetIdentifier": "subnet-06b798d37bd4d2613",
                "SubnetAvailabilityZone": {
                    "Name": "ap-northeast-1a"
                },
                "SubnetOutpost": {},
                "SubnetStatus": "Active"
            },
            {
                "SubnetIdentifier": "subnet-023129f92a48faa7e",
                "SubnetAvailabilityZone": {
                    "Name": "ap-northeast-1c"
                },
                "SubnetOutpost": {},
                "SubnetStatus": "Active"
            }
        ],
        "DBSubnetGroupArn": "arn:aws:rds:ap-northeast-1:557690581423:subgrp:lab-private-dbsubnets",
        "SupportedNetworkTypes": [
            "IPV4"
        ]
    }
}
### TABLE 
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws rds describe-db-subnet-groups \
  --region "$REGION" \
  --db-subnet-group-name "$DB_SUBNET_GROUP" \
  --query "DBSubnetGroups[0].Subnets[].{SubnetId:SubnetIdentifier,AZ:SubnetAvailabilityZone.Name}" \
  --output table
-------------------------------------------------
|            DescribeDBSubnetGroups             |
+------------------+----------------------------+
|        AZ        |         SubnetId           |
+------------------+----------------------------+
|  ap-northeast-1a |  subnet-06b798d37bd4d2613  |
|  ap-northeast-1c |  subnet-023129f92a48faa7e  |
+------------------+----------------------------+



############################################

##########################################################################


#### 3.2 Create DB (not public)

aws rds create-db-instance \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --engine mysql \
  --db-instance-class db.t3.micro \
  --allocated-storage 20 \
  --master-username "$DB_USER" \
  --master-user-password "$DB_PASS" \
  --vpc-security-group-ids "$RDS_SG_ID" \
  --db-subnet-group-name "$DB_SUBNET_GROUP" \
  --no-publicly-accessible

#### Wait until available:
aws rds wait db-instance-available --region "$REGION" --db-instance-identifier "$DB_ID"
echo "RDS is available"

#### Grab endpoint:

export DB_ENDPOINT="$(aws rds describe-db-instances \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].Endpoint.Address" --output text)"

echo "DB_ENDPOINT=$DB_ENDPOINT"
### Show it is NOT public + show endpoint

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws rds describe-db-instances \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].{Status:DBInstanceStatus,PubliclyAccessible:PubliclyAccessible,Endpoint:Endpoint.Address,Port:Endpoint.Port,SubnetGroup:DBSubnetGroup.DBSubnetGroupName,VpcSecurityGroups:VpcSecurityGroups[].VpcSecurityGroupId}" \
  --output table
-----------------------------------------------------------------------------------
|                               DescribeDBInstances                               |
+---------------------+-----------------------------------------------------------+
|  Endpoint           |  lab-mysql.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com  |
|  Port               |  3306                                                     |
|  PubliclyAccessible |  False                                                    |
|  Status             |  available                                                |
|  SubnetGroup        |  lab-private-dbsubnets                                    |
+---------------------+-----------------------------------------------------------+
||                               VpcSecurityGroups                               ||
|+-------------------------------------------------------------------------------+|
||  sg-001b40d6a6334fb9d                                                         ||
|+-------------------------------------------------------------------------------+|

#######################################################################
### Get the DB endpoint (and confirm status)
export DB_ENDPOINT="$(aws rds describe-db-instances \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].Endpoint.Address" \
  --output text)"

export DB_PORT="$(aws rds describe-db-instances \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].Endpoint.Port" \
  --output text)"

export DB_STATUS="$(aws rds describe-db-instances \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].DBInstanceStatus" \
  --output text)"

echo "DB_STATUS=$DB_STATUS"
echo "DB_ENDPOINT=$DB_ENDPOINT"
echo "DB_PORT=$DB_PORT"


*DB_STATUS=available*
*DB_ENDPOINT=lab-mysql.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com*
*DB_PORT=3306*


#### ## 4) Create Secrets Manager secret (format app expects)

Your user-data app reads JSON keys `username/password/host/port/dbname`.

aws secretsmanager create-secret \
  --region "$REGION" \
  --name "$SECRET_ID" \
  --secret-string "{\"username\":\"$DB_USER\",\"password\":\"$DB_PASS\",\"host\":\"$DB_ENDPOINT\",\"port\":$DB_PORT,\"dbname\":\"labdb\"}"

{
    *"ARN": "arn:aws:secretsmanager:ap-northeast-1:557690581423:secret:lab/rds/mysql-0kz48P",*
    *"Name": "lab/rds/mysql",*
    *"VersionId": "3c24d3c9-bc8e-434b-acd2-4269ef9be69c"*
}
######################################################################
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ aws secretsmanager get-secret-value \
  --region "$REGION" \
  --secret-id "$SECRET_ID" \
  --query "SecretString" \
  --output text
  
*{"username":"admin","password":"Nicholas111317!","host":"lab-mysql.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com","port":3306,"dbname":"labdb"}*

########################################################################
#### ## 5) Create IAM Role + inline policy + instance profile

Get account id:

export ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
echo "ACCOUNT_ID=$ACCOUNT_ID"

*ACCOUNT_ID=557690581423*

#### 5.1 Trust policy (EC2 assumes role)

export ROLE_NAME="lab-ec2-role"

cat > trust.json <<'JSON'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "ec2.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
JSON

aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://trust.json

#### ### 5.2 Inline least-privilege policy for this one secret

Matches your inline policy template.

1a_inline_policy

cat > inline_policy.json <<<font color="#000000">JSON</font>
<font color="#000000">{</font>
<font color="#000000">  "Version": "2012-10-17",</font>
<font color="#000000">  "Statement": [{</font>
<font color="#000000">    "Sid": "ReadSpecificSecret",</font>
<font color="#000000">    "Effect": "Allow",</font>
<font color="#000000">    "Action": ["secretsmanager:GetSecretValue"],</font>
<font color="#000000">    "Resource": "arn:aws:secretsmanager:$REGION:$ACCOUNT_ID:secret:$SECRET_ID*"</font>
<font color="#000000">  }]</font>
<font color="#000000">}</font>
<font color="#000000">JSON</font>


aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "lab-read-secret-inline" \
  --policy-document file:///tmp/inline_policy.json
Proof the inline policy is attached
aws iam list-role-policies --role-name "$ROLE_NAME" --output table
------------------------------
|      ListRolePolicies      |
+----------------------------+
||        PolicyNames       ||
|+--------------------------+|
||  lab-read-secret-inline  ||
|+--------------------------+|
######################################################################
### View the policy document back:

aws iam get-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "lab-read-secret-inline" \
  --query "PolicyDocument" \
  --output json
*{*
    *"Version": "2012-10-17",*
    *"Statement": [*
        *{*
            *"Sid": "ReadSpecificSecret",*
            *"Effect": "Allow",*
            *"Action": [*
                *"secretsmanager:GetSecretValue"*
            *],*
            *"Resource": "arn:aws:secretsmanager:ap-northeast-1:557690581423:secret:lab/rds/mysql*"*
        *}*
    *]*
*}*


#### 5.3 Instance profile (attach role)

aws iam create-instance-profile --instance-profile-name "$PROFILE_NAME"
aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE_NAME" --role-name "$ROLE_NAME"
#### export PROFILE_NAME="lab-ec2-profile"#### echo "PROFILE_NAME=$PROFILE_NAME"
#### echo "ROLE_NAME=$ROLE_NAME"
*PROFILE_NAME=lab-ec2-profile*
*ROLE_NAME=lab-ec2-role*

### 5.4 Create a PUBLIC subnet in ap-northeast-1a

export PUBLIC_SUBNET_ID="$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --availability-zone ap-northeast-1a \
  --cidr-block 10.10.10.0/24 \
  --query "Subnet.SubnetId" --output text)"

aws ec2 modify-subnet-attribute \
  --region "$REGION" \
  --subnet-id "$PUBLIC_SUBNET_ID" \
  --map-public-ip-on-launch

aws ec2 create-tags \
  --region "$REGION" \
  --resources "$PUBLIC_SUBNET_ID" \
  --tags Key=Name,Value=lab-public-1

echo "PUBLIC_SUBNET_ID=$PUBLIC_SUBNET_ID"
*PUBLIC_SUBNET_ID=subnet-0654bd3d98b921db6*

#### Proof it’s public (table):
aws ec2 describe-subnets \
  --region "$REGION" \
  --filters "Name=subnet-id,Values=$PUBLIC_SUBNET_ID" \
  --query "Subnets[0].{SubnetId:SubnetId,AZ:AvailabilityZone,CIDR:CidrBlock,PublicIP:MapPublicIpOnLaunch,Name:Tags[?Key=='Name']|[0].Value}" \
  --output table

------------------------------------------
|             DescribeSubnets            |
+-----------+----------------------------+
|  AZ        |  ap-northeast-1a                    |
|  CIDR     |  10.10.10.0/24                        |
|  Name    |  lab-public-1                          |
|  PublicIP |  True                                       |
|  SubnetId |  subnet-0654bd3d98b921db6  |
+-----------+----------------------------+
### Create and attach an Internet Gateway (IGW)
export IGW_ID="$(aws ec2 create-internet-gateway \
  --region "$REGION" \
  --query "InternetGateway.InternetGatewayId" --output text)"

aws ec2 attach-internet-gateway \
  --region "$REGION" \
  --internet-gateway-id "$IGW_ID" \
  --vpc-id "$VPC_ID"

echo "IGW_ID=$IGW_ID"
*IGW_ID=igw-0b0d2c94e9a408bcf*

### Create a public route table + default route to IGW

export PUBLIC_RT_ID="$(aws ec2 create-route-table \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --query "RouteTable.RouteTableId" --output text)"

aws ec2 create-route \
  --region "$REGION" \
  --route-table-id "$PUBLIC_RT_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"

aws ec2 associate-route-table \
  --region "$REGION" \
  --route-table-id "$PUBLIC_RT_ID" \
  --subnet-id "$PUBLIC_SUBNET_ID"

aws ec2 create-tags \
  --region "$REGION" \
  --resources "$PUBLIC_RT_ID" \
  --tags Key=Name,Value=lab-public-rt

echo "PUBLIC_RT_ID=$PUBLIC_RT_ID"

*{*
    *"Return": true*
*}*

*{*
    *"AssociationId": "rtbassoc-09fb3334e9e7eb2ce",*
    *"AssociationState": {*
        *"State": "associated"*
    *}*
*}*

*PUBLIC_RT_ID=rtb-0b595eaa86d1d1617*

### proof the route exists (table):
aws ec2 describe-route-tables \
  --region "$REGION" \
  --route-table-ids "$PUBLIC_RT_ID" \
  --query "RouteTables[0].Routes" \
  --output table
---------------------------------------------------------------------------------
*|                              DescribeRouteTables                              |*
*+----------------------+-------------------------+--------------------+---------+*
*| DestinationCidrBlock |        GatewayId              |      Origin               |  State  |*
*+----------------------+-------------------------+--------------------+---------+*
*|  10.10.0.0/16            |  local                                |  CreateRouteTable  |  active |*
*|  0.0.0.0/0                  |  igw-0b0d2c94e9a408bcf  |  CreateRoute         |  active |*
*+----------------------+-------------------------+--------------------+---------+*




#### ## 6) Launch EC2 with your user-data script

You uploaded the exact user-data (`1a_user_data.sh`). Make sure it’s in your current folder.

If you’re running this from a folder that contains it already, verify:

ls -la 1a_user_data.sh
###################################################################
#### Create the instance profile
aws iam create-instance-profile \
  --instance-profile-name "$PROFILE_NAME"
*{*
    *"InstanceProfile": {*
        *"Path": "/",*
        *"InstanceProfileName": "lab-ec2-profile",*
        *"InstanceProfileId": "AIPAYDWHS6GXXRXPPKZF4",*
        *"Arn": "arn:aws:iam::557690581423:instance-profile/lab-ec2-profile",*
        *"CreateDate": "2026-01-16T18:06:05+00:00",*
        *"Roles": []*
    *}*
*}*

### Add the role to the instance profile
aws iam add-role-to-instance-profile \
  --instance-profile-name "$PROFILE_NAME" \
  --role-name "$ROLE_NAME"

### Proof (table)
aws iam get-instance-profile \
  --instance-profile-name "$PROFILE_NAME" \
  --query "InstanceProfile.{Name:InstanceProfileName,Arn:Arn,Roles:Roles[].RoleName}" \
  --output table
  ------------------------------------------------------------------------
|                          GetInstanceProfile                          |
+------+---------------------------------------------------------------+
|  Arn |  arn:aws:iam::557690581423:instance-profile/lab-ec2-profile   |
|  Name|  lab-ec2-profile                                              |
+------+---------------------------------------------------------------+
||                                Roles                               ||
|+--------------------------------------------------------------------+|
||  lab-ec2-role                                                      ||
|+--------------------------------------------------------------------+|





####################################################################
##### Launch instance:

export INSTANCE_ID="$(aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$AMI_ID" \
  --instance-type t3.micro \
  --key-name "$KEY_NAME" \
  --subnet-id "$PUBLIC_SUBNET_ID" \
  --security-group-ids "$EC2_SG_ID" \
  --iam-instance-profile Name="$PROFILE_NAME" \
  --user-data file://1a_user_data.sh \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=lab-ec2-app}]" \
  --query "Instances[0].InstanceId" --output text)"

echo "INSTANCE_ID=$INSTANCE_ID"
aws ec2 wait instance-running --region "$REGION" --instance-ids "$INSTANCE_ID"
*INSTANCE_ID=i-00e9ee96ac4a94ebd*

#### Get public IP:

export EC2_IP="$(aws ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text)"

echo "EC2_IP=$EC2_IP"
52.195.237.124
## EC2 â†’ RDS Notes App

POST /add?note=hello

GET /list

### 7) App test (browser / curl)
Your app endpoints are:

- `/init`
    
- `/add?note=...`
    
- `/list`
    
    1a_user_data

curl -s "http://$EC2_IP/init"
curl -s "http://$EC2_IP/add?note=first_note"
curl -s "http://$EC2_IP/list"
####################################################################
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/New Obsidian/AWS/AWS-Armageddon/Lab1a$ curl -i "http://$EC2_IP/init"
curl -i "http://$EC2_IP/add?note=first_note"
curl -i "http://$EC2_IP/list"
HTTP/1.1 500 INTERNAL SERVER ERROR
Server: Werkzeug/3.1.5 Python/3.9.25
Date: Fri, 16 Jan 2026 18:20:27 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 265
Connection: close

<!doctype html>
<html lang=en>
<title>500 Internal Server Error</title>
<h1>Internal Server Error</h1>
<p>The server encountered an internal error and was unable to complete your request. Either the server is overloaded or there is an error in the applicat
ion.</p>
HTTP/1.1 500 INTERNAL SERVER ERROR
Server: Werkzeug/3.1.5 Python/3.9.25
Date: Fri, 16 Jan 2026 18:20:28 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 265
Connection: close

<!doctype html>
<html lang=en>
<title>500 Internal Server Error</title>
<h1>Internal Server Error</h1>
<p>The server encountered an internal error and was unable to complete your request. Either the server is overloaded or there is an error in the applicat
ion.</p>
HTTP/1.1 500 INTERNAL SERVER ERROR
Server: Werkzeug/3.1.5 Python/3.9.25
Date: Fri, 16 Jan 2026 18:20:29 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 265
Connection: close


####################################################################
If `/init` hangs: it’s almost always SG-to-SG rule, wrong subnets, or role/secret mismatch.

### 8) Run the gate scripts (grader-style)
Your final check doc expects these scripts to exist in your repo folder:

- `gate_secrets_and_role.sh`
    
- `gate_network_db.sh`
    
- `run_all_gates.sh`
    
    1a_final_check
    
### From your workstation:

chmod +x gate_secrets_and_role.sh gate_network_db.sh run_all_gates.sh

REGION="$REGION" \
INSTANCE_ID="$INSTANCE_ID" \
SECRET_ID="$SECRET_ID" \
DB_ID="$DB_ID" \
./run_all_gates.sh

Strict options (if your class requires):

REQUIRE_ROTATION=true \
CHECK_PRIVATE_SUBNETS=true \
REGION="$REGION" INSTANCE_ID="$INSTANCE_ID" SECRET_ID="$SECRET_ID" DB_ID="$DB_ID" \
./run_all_gates.sh

Expected outputs (files + exit code) are described in the final check doc.

1a_final_check
Create a PUBLIC subnet in ap-northeast-1a
## 9) Quick “did we wire it right?” sanity checks (CLI)

# DB is not public
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].PubliclyAccessible" --output text

# RDS SG inbound references EC2 SG (SG-to-SG)
aws ec2 describe-security-groups --region "$REGION" --group-ids "$RDS_SG_ID" \
  --query "SecurityGroups[0].IpPermissions" --output json

# EC2 has instance profile attached
aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].IamInstanceProfile.Arn" --output text



### If your project “still won’t work” (most common mismatch)

Your app **hard-codes** `SECRET_ID=lab/rds/mysql` in systemd env.

1a_user_data

  
So either:

- keep `SECRET_ID="lab/rds/mysql"` exactly (recommended), **or**
    
- edit user-data to match your secret name.
    

---

If you paste your **actual** `VPC_ID`, `PUBLIC_SUBNET_ID`, `PRIVATE_SUBNET_A/B`, and tell me whether your gate scripts are present in the repo folder, I can tailor the runbook to your exact environment (no placeholders).