aws ec2 describe-security-groups \
  --region us-east-1 \
  --query "SecurityGroups[].{GroupId:GroupId,Name:GroupName,VpcId:VpcId}" \
  --output table
  -----------------------------------------------------------------
|                    DescribeSecurityGroups                     |
+-----------------------+-------------+-------------------------+
|        GroupId        |    Name     |          VpcId          |
+-----------------------+-------------+-------------------------+
|  sg-0aed5557f032554c3 |  default    |  vpc-0e19e66167ef138e5  |
|  sg-0b134cc8eeeccabe3 |  default    |  vpc-0a45cfd3583bdadbf  |
|  sg-06cf8e6f09f34fdd7 |  ec2-lab-sg |  vpc-0a45cfd3583bdadbf  |
|  sg-0eefdd7685848ee5c |  rds-lab-sg |  vpc-0a45cfd3583bdadbf  |
+-----------------------+-------------+-------------------------+
###############################################################################
aws ec2 describe-security-groups \
  --group-ids sg-06cf8e6f09f34fdd7 \
  --region us-east-1 \
  --output json
  {
    "SecurityGroups": [
        {
            "GroupId": "sg-06cf8e6f09f34fdd7",
            "IpPermissionsEgress": [
                {
                    "IpProtocol": "-1",
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                }
            ],
            "VpcId": "vpc-0a45cfd3583bdadbf",
            "SecurityGroupArn": "arn:aws:ec2:us-east-1:557690581423:security-group/sg-06cf8e6f09f34fdd7",
            "OwnerId": "557690581423",
            "GroupName": "ec2-lab-sg",
            "Description": "EC2 lab SG",
            "IpPermissions": [
                {
                    "IpProtocol": "tcp",
                    "FromPort": 80,
                    "ToPort": 80,
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                },
                {
                    "IpProtocol": "tcp",
                    "FromPort": 22,
                    "ToPort": 22,
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "73.107.137.224/32"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                },
                {
                    "IpProtocol": "tcp",
                    "FromPort": 5000,
                    "ToPort": 5000,
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                }
            ]
        }
    ]
}
#####################################################################
aws ec2 describe-instances \
  --filters Name=instance.group-id,Values=sg-06cf8e6f09f34fdd7 \
  --region us-east-1 \
  --query "Reservations[].Instances[].InstanceId" \
  --output table
  -------------------------
|   DescribeInstances   |
+-----------------------+
|  i-05d98187205214495  |
+-----------------------+
#########################################################################
aws rds describe-db-instances \
  --region us-east-1 \
  --query "DBInstances[?contains(VpcSecurityGroups[].VpcSecurityGroupId, 'sg-0eefdd7685848ee5c')].DBInstanceIdentifier" \
  --output table
  ---------------------
|DescribeDBInstances|
+-------------------+
|  lab-mysql        |
+-------------------+
###############################################################################
aws rds describe-db-instances \
  --region us-east-1 \
  --query "DBInstances[].{DB:DBInstanceIdentifier,Engine:Engine,Public:PubliclyAccessible,Vpc:DBSubnetGroup.VpcId}" \
  --output table
  ------------------------------------------------------------
|                    DescribeDBInstances                   |
+-----------+---------+---------+--------------------------+
|    DB     | Engine  | Public  |           Vpc            |
+-----------+---------+---------+--------------------------+
|  lab-mysql|  mysql  |  False  |  vpc-0a45cfd3583bdadbf   |
+-----------+---------+---------+--------------------------+
##################################################################################
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1a$ aws rds describe-db-instances \
>   --region us-east-1 \
>   --region us-east-1 \
>   --db-instance-identifier lab-mysql \
>   --db-instance-identifier lab-mysql \
>   --query "DBInstances[0].{
>   --query "DBInstances[0].{
>     ID:DBInstanceIdentifier,
>     ID:DBInstanceIdentifier,
>     Status:DBInstanceStatus,
>     Status:DBInstanceStatus,
>     Engine:Engine,
>     Class:DBInstanceClass,
>     Engine:Engine,
>     Class:DBInstanceClass,
>     Public:PubliclyAccessible,
>     Class:DBInstanceClass,
>     Public:PubliclyAccessible,
>     Public:PubliclyAccessible,
>     Endpoint:Endpoint.Address
>     Endpoint:Endpoint.Address
>   }" \
>   }" \
>   --output table
--------------------------------------------------------------------
|                        DescribeDBInstances                       |
|                        DescribeDBInstances                       |
+----------+-------------------------------------------------------+
|  Class   |  db.t3.micro                                          |
|  Endpoint|  lab-mysql.cs3cu6i6843p.us-east-1.rds.amazonaws.com   |
|  Engine  |  mysql                                                |
|  ID      |  lab-mysql                                            |
|  Public  |  False                                                |
|  Status  |  available                                            |
+----------+-------------------------------------------------------+
|  Status  |  available                                            |
+----------+-------------------------------------------------------+

|  Status  |  available                                            |
+----------+-------------------------------------------------------+
|  Status  |  available                                            |
+----------+-------------------------------------------------------+
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
+----------+-------------------------------------------------------+
|  Status  |  available                                            |
+----------+-------------------------------------------------------+
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
|  Status  |  available                                            |
+----------+-------------------------------------------------------+

#####################################################################################


###############################################################################
aws rds describe-db-instances \
  --db-instance-identifier lab-mysql \
  --region us-east-1 \
  --output json
CopyTagsToSnapshot": false,
            "MonitoringInterval": 0,
            "DBInstanceArn": "arn:aws:rds:us-east-1:557690581423:db:lab-mysql",
            "IAMDatabaseAuthenticationEnabled": false,
            "DatabaseInsightsMode": "standard",
            "PerformanceInsightsEnabled": false,
            "DeletionProtection": false,
            "AssociatedRoles": [],
            "TagList": [],
            "CustomerOwnedIpEnabled": false,
            "ActivityStreamStatus": "stopped",
            "BackupTarget": "region",
            "NetworkType": "IPV4",
            "StorageThroughput": 0,
            "CertificateDetails": {
                "CAIdentifier": "rds-ca-rsa2048-g1",
                "ValidTill": "2027-01-26T04:10:51+00:00"
            },
            "DedicatedLogVolume": false,
            "IsStorageConfigUpgradeAvailable": false,
            "EngineLifecycleSupport": "open-source-rds-extended-support"
        }
    ]
}
  ###############################################################################
  aws rds describe-db-instances \
  --region us-east-1 \
  --db-instance-identifier lab-mysql \
  --query "DBInstances[0].{
    ID:DBInstanceIdentifier,
    Status:DBInstanceStatus,
    Engine:Engine,
    Class:DBInstanceClass,
    Public:PubliclyAccessible,
    Endpoint:Endpoint.Address
  }" \
  --output table
--------------------------------------------------------------------
|                        DescribeDBInstances                       |
|                        DescribeDBInstances                       |
+----------+-------------------------------------------------------+
|  Class   |  db.t3.micro                                          |
|  Endpoint|  lab-mysql.cs3cu6i6843p.us-east-1.rds.amazonaws.com   |
|  Engine  |  mysql                                                |
|  ID      |  lab-mysql                                            |
|  Public  |  False                                                |
|  Status  |  available                                            |
+----------+-------------------------------------------------------+

  ###########################################################################
  aws rds describe-db-subnet-groups \
  --region us-east-1 \
  --query "DBSubnetGroups[].{Name:DBSubnetGroupName,Vpc:VpcId,Subnets:Subnets[].SubnetIdentifier}" \
  --output table
----------------------------------------------------
|              DescribeDBSubnetGroups              |
+------------------------+-------------------------+
|          Name          |           Vpc           |
+------------------------+-------------------------+
|  lab-private-dbsubnets |  vpc-0a45cfd3583bdadbf  |
+------------------------+-------------------------+
||                     Subnets                    ||
|+------------------------------------------------+|
||  subnet-055fba2978aeb84e9                      ||
||  subnet-05b8cfcbbfd90d729                      ||
|+------------------------------------------------+|
  #############################################################################
  aws rds describe-db-instances \
  --db-instance-identifier lab-mysql \
  --region us-east-1 \
  --query "DBInstances[].PubliclyAccessible" \
  --output text
False
  ###########################################################################
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1a$ aws secretsmanager list-secrets \
>   --region us-east-1 \
>   --region us-east-1 \
>   --query "SecretList[].{Name:Name,ARN:ARN,Rotation:RotationEnabled}" \
>   --output table
--------------------------------------------------------------------------------------------------------------------
|                                                    ListSecrets                                                   |
+--------------------------------------------------------------------------------+--------------------+------------+
|                                       ARN                                      |       Name         | Rotation   |
+--------------------------------------------------------------------------------+--------------------+------------+
|  arn:aws:secretsmanager:us-east-1:557690581423:secret:ceklab1/rds/mysql-SiLWEo |  ceklab1/rds/mysql |  None      |
|  arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i     |  lab/rds/mysql     |  None      |
+--------------------------------------------------------------------------------+--------------------+------------+
##################################################################################
aws secretsmanager list-secrets \
  --region us-east-1 \
  --query "SecretList[].Name" \
  --output table
-----------------------
|     ListSecrets     |
+---------------------+
|  ceklab1/rds/mysql  |
|  lab/rds/mysql      |
+---------------------+

  #################################################################################
aws secretsmanager describe-secret \
  --region us-east-1 \
  --secret-id lab/rds/mysql \
  --output json
{
    "ARN": "arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i",
    "Name": "lab/rds/mysql",
    "LastChangedDate": "2026-01-25T23:25:15.424000-05:00",
    "LastAccessedDate": "2026-01-26T19:00:00-05:00",
    "VersionIdsToStages": {
        "1529432a-b319-4674-9a2e-5bb20329500d": [
            "AWSCURRENT"
        ]
    },
    "CreatedDate": "2026-01-25T23:25:15.381000-05:00"
}
##############################################################################
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1a$ aws secretsmanager get-resource-policy \
>   --region us-east-1 \       
>   --secret-id lab/rds/mysql \
>   --output json
{
    "ARN": "arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i",
    "Name": "lab/rds/mysql"
}

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1a$ aws secretsmanager get-resource-policy \
>   --region us-east-1 \
>   --secret-id ceklab1/rds/mysql \
>   --output json
{
    "ARN": "arn:aws:secretsmanager:us-east-1:557690581423:secret:ceklab1/rds/mysql-SiLWEo",
    "Name": "ceklab1/rds/mysql"
}
###################################################################################################
 aws ec2 describe-instances \
>   --region us-east-1 \
>   --query "Reservations[].Instances[].{Id:InstanceId,State:State.Name,Name:Tags[?Key=='Name']|[0].Value}" \
>   --output table
---------------------------------------------------
|                DescribeInstances                |
+----------------------+---------------+----------+
|          Id          |     Name      |  State   |
+----------------------+---------------+----------+
|  i-05d98187205214495 |  lab-ec2-app  |  running |
+----------------------+---------------+----------+
#################################################################################
aws ec2 describe-instances \
  --instance-ids i-05d98187205214495 \
  --region us-east-1 \
  --query "Reservations[].Instances[].IamInstanceProfile.Arn" \
  --output text
arn:aws:iam::557690581423:instance-profile/lab-ec2-profile
##########################################################################
aws iam list-roles \
  --query "Roles[].RoleName" \
  --output table
-------------------------------------------
|                ListRoles                |
+-----------------------------------------+
|  AWSServiceRoleForAutoScaling           |
|  AWSServiceRoleForEC2Spot               |
|  AWSServiceRoleForElasticLoadBalancing  |
|  AWSServiceRoleForGlobalAccelerator     |
|  AWSServiceRoleForRDS                   |
|  AWSServiceRoleForResourceExplorer      |
|  AWSServiceRoleForSupport               |
|  AWSServiceRoleForTrustedAdvisor        |
|  AWSServiceRoleForVPCTransitGateway     |
|  ck-web-asg-role                        |
|  lab-ec2-role                           |
+-----------------------------------------+
####################################################################################
aws iam list-attached-role-policies \
  --role-name lab-ec2-role \
  --output table
--------------------------------------------------------------------------
|                        ListAttachedRolePolicies                        |
+------------------------------------------------------------------------+
||                           AttachedPolicies                           ||
|+------------+---------------------------------------------------------+|
||  PolicyArn |  arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore   ||
||  PolicyName|  AmazonSSMManagedInstanceCore                           ||
|+------------+---------------------------------------------------------+|
#############################################################################
aws iam list-role-policies \
  --role-name lab-ec2-role \
  --output table
------------------
|ListRolePolicies|
+----------------+
########################################################################
aws iam get-policy-version \
  --policy-arn arn:aws:iam::aws:policy/SecretsManagerReadWrite \
  --version-id v1 \
  --output json
  {
    "PolicyVersion": {
        "Document": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": [
                        "secretsmanager:*",
                        "cloudformation:CreateChangeSet",
                        "cloudformation:DescribeChangeSet",
                        "cloudformation:DescribeStackResource",
                        "cloudformation:DescribeStacks",
                        "cloudformation:ExecuteChangeSet",
                        "ec2:DescribeSecurityGroups",
                        "ec2:DescribeSubnets",
                        "ec2:DescribeVpcs",
                        "kms:DescribeKey",
                        "kms:ListAliases",
                        "kms:ListKeys",
                        "lambda:ListFunctions",
                        "rds:DescribeDBInstances",
                        "tag:GetResources"
                    ],
                    "Effect": "Allow",
                    "Resource": "*"
                },
                {
                    "Action": [
                        "lambda:AddPermission",
                        "lambda:CreateFunction",
                        "lambda:GetFunction",
                        "lambda:InvokeFunction",
                        "lambda:UpdateFunctionConfiguration"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:lambda:*:*:function:SecretsManager*"
                },
                {
                    "Action": [
                        "serverlessrepo:CreateCloudFormationChangeSet"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:serverlessrepo:*:*:applications/SecretsManager*"
                },
                {
                    "Action": [
                        "s3:GetObject"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:s3:::awsserverlessrepo-changesets*"
                }
            ]
        },
        "VersionId": "v1",
        "IsDefaultVersion": false,
        "CreateDate": "2018-04-04T18:05:29+00:00"
    }
}
##############################################################################
aws ec2 describe-instances \
  --region us-east-1 \
  --instance-ids i-05d98187205214495 \
  --query "Reservations[0].Instances[0].SecurityGroups" \
  --output table
i-05d98187205214495
----------------------------------------
|           DescribeInstances          |
+-----------------------+--------------+
|        GroupId        |  GroupName   |
+-----------------------+--------------+
|  sg-06cf8e6f09f34fdd7 |  ec2-lab-sg  |
+-----------------------+--------------+

#####################################################################################
aws sts get-caller-identity
{
    "UserId": "AIDAYDWHS6GXTCANQIJNY",
    "Account": "557690581423",
    "Arn": "arn:aws:iam::557690581423:user/AWSCLI"
}
#####################################################################################
aws secretsmanager describe-secret \
  --region us-east-1 \
  --secret-id lab/rds/mysql \
  --output table
---------------------------------------------------------------------------------------------------
|                                         DescribeSecret                                          |
+------------------+------------------------------------------------------------------------------+
|  ARN             |  arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i   |
|  CreatedDate     |  2026-01-25T23:25:15.381000-05:00                                            |
|  LastAccessedDate|  2026-01-26T19:00:00-05:00                                                   |
|  LastChangedDate |  2026-01-25T23:25:15.424000-05:00                                            |
|  Name            |  lab/rds/mysql                                                               |
+------------------+------------------------------------------------------------------------------+
||                                      VersionIdsToStages                                       ||
|+-----------------------------------------------------------------------------------------------+|
|||                            1529432a-b319-4674-9a2e-5bb20329500d                             |||
||+---------------------------------------------------------------------------------------------+||
|||  AWSCURRENT                                                                                 |||
||+---------------------------------------------------------------------------------------------+||
##################################################################################################
aws secretsmanager describe-secret \
  --region us-east-1 \
  --secret-id ceklab1/rds/mysql \
  --output table
-------------------------------------------------------------------------------------------------------
|                                           DescribeSecret                                            |
+------------------+----------------------------------------------------------------------------------+
|  ARN             |  arn:aws:secretsmanager:us-east-1:557690581423:secret:ceklab1/rds/mysql-SiLWEo   |
|  CreatedDate     |  2026-01-19T13:46:49.604000-05:00                                                |
|  LastAccessedDate|  2026-01-18T19:00:00-05:00                                                       |
|  LastChangedDate |  2026-01-19T17:24:35.547000-05:00                                                |
|  Name            |  ceklab1/rds/mysql                                                               |
+------------------+----------------------------------------------------------------------------------+
||                                        VersionIdsToStages                                         ||
|+---------------------------------------------------------------------------------------------------+|
|||                              terraform-20260119185222679900000006                               |||
||+-------------------------------------------------------------------------------------------------+||
|||  AWSCURRENT                                                                                     |||
||+-------------------------------------------------------------------------------------------------+||


 A) Why is DB inbound source restricted to the EC2 security group? B) What port does MySQL use? C) Why is Secrets Manager better than storing creds in code/user-data?

