
## 🥇 1) EC2 INSTANCE (highest cost + active consumer)

**Why first:**

- Actively running (compute + EBS)
    
- Uses IAM role, SG, subnet, route, secret, DB
    

### Stop (safe if you may restart later)

aws ec2 stop-instances \
  --region ap-northeast-1 \
  --instance-ids i-00e9ee96ac4a94ebd


### Or terminate (final)

aws ec2 terminate-instances \
  --region ap-northeast-1 \
  --instance-ids i-00e9ee96ac4a94ebd

**{**
    **"StoppingInstances": [**
        **{**
            **"InstanceId": "i-00e9ee96ac4a94ebd",**
            **"CurrentState": {**
                **"Code": 64,**
                **"Name": "stopping"**
            **},**
            **"PreviousState": {**
                **"Code": 16,**
                **"Name": "running"**
            **}**
        **}**
    **]**
**}**

📌 **If you terminate EC2, everything downstream becomes detachable.**

---

## 🥈 2) RDS INSTANCE (very important — NOT FREE)

**Why second:**

- RDS bills **even when idle**
    
- Depends on subnet group + SG
    

### Disable deletion protection (if enabled)

aws rds modify-db-instance \
  --region ap-northeast-1 \
  --db-instance-identifier lab-mysql \
  --no-deletion-protection \
  --apply-immediately
**{**
    **"DBInstance": {**
        **"DBInstanceIdentifier": "lab-mysql",**
        **"DBInstanceClass": "db.t3.micro",**
            **"Address": "lab-mysql.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com",**
            **"Port": 3306,**
            **"HostedZoneId": "Z24O6O9L7SGTNB"**
        **},**
        **"AllocatedStorage": 20,**
        **"InstanceCreateTime": "2026-01-16T16:43:12.080000+00:00",**
        **"PreferredBackupWindow": "16:37-17:07",**
        **"BackupRetentionPeriod": 1,**
        **"DBSecurityGroups": [],**
        **"VpcSecurityGroups": [**
            **{**
                **"VpcSecurityGroupId": "sg-001b40d6a6334fb9d",**
                **"Status": "active"**
            **}**
        **],**
        **"DBParameterGroups": [**
            **{**
                **"DBParameterGroupName": "default.mysql8.0",**
                **"ParameterApplyStatus": "in-sync"**
            **}**
        **],**
        **"AvailabilityZone": "ap-northeast-1c",**
        **"DBSubnetGroup": {**
            **"DBSubnetGroupName": "lab-private-dbsubnets",**
            **"DBSubnetGroupDescription": "Lab1a private DB subnet group",**
            **"VpcId": "vpc-0f788f9702ce28e45",**
            **"SubnetGroupStatus": "Complete",**
            **"Subnets": [**
                **{**
                    **"SubnetIdentifier": "subnet-06b798d37bd4d2613",**
                    **"SubnetAvailabilityZone": {**
                        **"Name": "ap-northeast-1a"**
                    **},**
                    **"SubnetOutpost": {},**
                    **"SubnetStatus": "Active"**
                **},**
                **{**
                    **"SubnetIdentifier": "subnet-023129f92a48faa7e",**
                    **"SubnetAvailabilityZone": {**
                        **"Name": "ap-northeast-1c"**
                    **},**
                    **"SubnetOutpost": {},**
                    **"SubnetStatus": "Active"**
                **}**
            **]**
        **},**
        **"PreferredMaintenanceWindow": "wed:15:36-wed:16:06",**
        **"PendingModifiedValues": {},**
        **"LatestRestorableTime": "2026-01-17T01:20:00+00:00",**
        **"MultiAZ": false,**
        **"EngineVersion": "8.0.43",**
        **"AutoMinorVersionUpgrade": true,**
        **"ReadReplicaDBInstanceIdentifiers": [],**
        **"LicenseModel": "general-public-license",**
        **"OptionGroupMemberships": [**
            **{**
                **"OptionGroupName": "default:mysql-8-0",**
                **"Status": "in-sync"**
            **}**
        **],**
        **"PubliclyAccessible": false,**
        **"StorageType": "gp2",**
        **"DbInstancePort": 0,**
        **"StorageEncrypted": false,**
        **"DbiResourceId": "db-X43UCGQDU4IZFTQDC7L6ID4UAA",**
        **"CACertificateIdentifier": "rds-ca-rsa2048-g1",**
        **"DomainMemberships": [],**
        **"CopyTagsToSnapshot": false,**
        **"MonitoringInterval": 0,**
        **"DBInstanceArn": "arn:aws:rds:ap-northeast-1:557690581423:db:lab-mysql",**
        **"IAMDatabaseAuthenticationEnabled": false,**
        **"DatabaseInsightsMode": "standard",**
        **"PerformanceInsightsEnabled": false,**
        **"DeletionProtection": false,**
        **"AssociatedRoles": [],**
        **"TagList": [],**
        **"CustomerOwnedIpEnabled": false,**
        **"BackupTarget": "region",**
        **"NetworkType": "IPV4",**
        **"StorageThroughput": 0,**
        **"CertificateDetails": {**
            **"CAIdentifier": "rds-ca-rsa2048-g1",**
            **"ValidTill": "2027-01-16T16:41:47+00:00"**
        **},**
        **"DedicatedLogVolume": false,**
        **"EngineLifecycleSupport": "open-source-rds-extended-support"**
    **}**
**}**



### Delete RDS (NO snapshot for lab)

aws rds delete-db-instance \
  --region ap-northeast-1 \
  --db-instance-identifier lab-mysql \
  --skip-final-snapshot
**{**
    **"DBInstance": {**
        **"DBInstanceIdentifier": "lab-mysql",**
        **"DBInstanceClass": "db.t3.micro",**
        **"Engine": "mysql",**
        **"DBInstanceStatus": "deleting",**
        **"MasterUsername": "admin",**
        **"Endpoint": {**
            **"Address": "lab-mysql.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com",**
            **"Port": 3306,**
            **"HostedZoneId": "Z24O6O9L7SGTNB"**
        **},**
        **"AllocatedStorage": 20,**
        **"InstanceCreateTime": "2026-01-16T16:43:12.080000+00:00",**
        **"PreferredBackupWindow": "16:37-17:07",**
        **"BackupRetentionPeriod": 1,**
        **"DBSecurityGroups": [],**
        **"VpcSecurityGroups": [**
            **{**
                **"VpcSecurityGroupId": "sg-001b40d6a6334fb9d",**
                **"Status": "active"**
            **}**
        **],**
        **"DBParameterGroups": [**
            **{**
                **"DBParameterGroupName": "default.mysql8.0",**
                **"ParameterApplyStatus": "in-sync"**
            **}**
        **],**
        **"AvailabilityZone": "ap-northeast-1c",**
        **"DBSubnetGroup": {**
            **"DBSubnetGroupName": "lab-private-dbsubnets",**
            **"DBSubnetGroupDescription": "Lab1a private DB subnet group",**
            **"VpcId": "vpc-0f788f9702ce28e45",**
            **"SubnetGroupStatus": "Complete",**
            **"Subnets": [**
                **{**
                    **"SubnetIdentifier": "subnet-06b798d37bd4d2613",**
                    **"SubnetAvailabilityZone": {**
                        **"Name": "ap-northeast-1a"**
                    **},**
                    **"SubnetOutpost": {},**
                    **"SubnetStatus": "Active"**
                **},**
                **{**
                    **"SubnetIdentifier": "subnet-023129f92a48faa7e",**
                    **"SubnetAvailabilityZone": {**
                        **"Name": "ap-northeast-1c"**
                    **},**
                    **"SubnetOutpost": {},**
                    **"SubnetStatus": "Active"**
                **}**
            **]**
        **},**
        **"PreferredMaintenanceWindow": "wed:15:36-wed:16:06",**
        **"PendingModifiedValues": {},**
        **"LatestRestorableTime": "2026-01-17T01:25:00+00:00",**
        **"MultiAZ": false,**
        **"EngineVersion": "8.0.43",**
        **"AutoMinorVersionUpgrade": true,**
        **"ReadReplicaDBInstanceIdentifiers": [],**
        **"LicenseModel": "general-public-license",**
        **"OptionGroupMemberships": [**
            **{**
                **"OptionGroupName": "default:mysql-8-0",**
                **"Status": "in-sync"**
            **}**
        **],**
        **"PubliclyAccessible": false,**
        **"StorageType": "gp2",**
        **"DbInstancePort": 0,**
        **"StorageEncrypted": false,**
        **"DbiResourceId": "db-X43UCGQDU4IZFTQDC7L6ID4UAA",**
        **"CACertificateIdentifier": "",**
        **"DomainMemberships": [],**
        **"CopyTagsToSnapshot": false,**
        **"MonitoringInterval": 0,**
        **"DBInstanceArn": "arn:aws:rds:ap-northeast-1:557690581423:db:lab-mysql",**
        **"IAMDatabaseAuthenticationEnabled": false,**
        **"DatabaseInsightsMode": "standard",**
        **"PerformanceInsightsEnabled": false,**
        **"DeletionProtection": false,**
        **"AssociatedRoles": [],**
        **"TagList": [],**
        **"CustomerOwnedIpEnabled": false,**
        **"BackupTarget": "region",**
        **"NetworkType": "IPV4",**
        **"StorageThroughput": 0,**
        **"DedicatedLogVolume": false,**
        **"EngineLifecycleSupport": "open-source-rds-extended-support"**
    **}**
**}**


⏱ Takes ~5–10 minutes.

---

## 🥉 3) DB SUBNET GROUP

**Why third:**

- Cannot delete while RDS exists
    

aws rds delete-db-subnet-group \
  --region ap-northeast-1 \
  --db-subnet-group-name lab-private-dbsubnets


---

## 🟡 4) SECRETS MANAGER SECRET

**Why now:**

- No active consumers remain
    
- Still bills monthly if kept
    

### Schedule deletion (default 7 days)

aws secretsmanager delete-secret \
  --region ap-northeast-1 \
  --secret-id lab/rds/mysql
**{**
    **"ARN": "arn:aws:secretsmanager:ap-northeast-1:557690581423:secret:lab/rds/mysql-0kz48P",**
    **"Name": "lab/rds/mysql",**
    **"DeletionDate": "2026-02-15T20:52:08.875000-05:00"**
**}**


### Or force immediate deletion (lab only)

aws secretsmanager delete-secret \
  --region ap-northeast-1 \
  --secret-id lab/rds/mysql \
  --force-delete-without-recovery

**{**
    **"ARN": "arn:aws:secretsmanager:ap-northeast-1:557690581423:secret:lab/rds/mysql-0kz48P",**
    **"Name": "lab/rds/mysql",**
    **"DeletionDate": "2026-01-16T20:55:20.083000-05:00"**
**}**


---

## 🟢 5) IAM CLEANUP (safe now)

**Why:**

- Nothing is using the role anymore
    

### Remove inline policy

aws iam delete-role-policy \
  --role-name lab-ec2-role \
  --policy-name lab-read-secret-inline


### Remove role from instance profile

aws iam remove-role-from-instance-profile \
  --instance-profile-name lab-ec2-profile \
  --role-name lab-ec2-role


### Delete instance profile

aws iam delete-instance-profile \
  --instance-profile-name lab-ec2-profile


### Delete role

aws iam delete-role \
  --role-name lab-ec2-role



---

## 🔵 6) SECURITY GROUPS

**Why now:**

- Must not be attached to anything
    

Delete in **this order**:

1. **RDS SG**
    
2. **EC2 SG**
    

aws ec2 delete-security-group \
  --region ap-northeast-1 \
  --group-id sg-001b40d6a6334fb9d
 **"Return": true,**
    **"GroupId": "sg-001b40d6a6334fb9d"**

aws ec2 delete-security-group \
  --region ap-northeast-1 \
  --group-id sg-0f932af801e33d267


---

## 🟣 7) NETWORKING (VPC teardown)

Only do this if the lab is **fully finished**.

### Delete subnets (order doesn’t matter)

aws ec2 delete-subnet --region ap-northeast-1 --subnet-id subnet-06b798d37bd4d2613
aws ec2 delete-subnet --region ap-northeast-1 --subnet-id subnet-023129f92a48faa7e
aws ec2 delete-subnet --region ap-northeast-1 --subnet-id <public-subnet-id>


### Detach & delete IGW

aws ec2 detach-internet-gateway \
  --region ap-northeast-1 \
  --internet-gateway-id <igw-id> \
  --vpc-id vpc-0f788f9702ce28e45

aws ec2 delete-internet-gateway \
  --region ap-northeast-1 \
  --internet-gateway-id <igw-id>


**Delete route tables (non-main)**

`aws ec2 delete-route-table --region ap-northeast-1 --route-table-id <rt-id>`

### Delete VPC

`aws ec2 delete-vpc \   --region ap-northeast-1 \   --vpc-id vpc-0f788f9702ce28e45`

---

# 🧠 Cost-Critical Summary (Non-Free Account)

|Priority|Resource|Why|
|---|---|---|
|🔴 1|EC2|Compute + EBS|
|🔴 2|RDS|**Always billing**|
|🟠 3|Secrets Manager|Monthly cost|
|🟡 4|IAM|Clean dependencies|
|🟢 5|SGs|Block VPC deletion|
|🔵 6|Networking|Zero cost but dependency-heavy|

---

## 📌 Instructor-Grade Line (you can use this verbatim)

> Resources were shut down in dependency-safe order: EC2 consumers first, followed by RDS producers, Secrets Manager, IAM roles, security groups, and finally networking components. This prevents orphaned dependencies and ongoing service charges.