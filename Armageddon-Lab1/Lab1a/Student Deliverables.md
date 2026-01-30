Screenshot of: RDS SG inbound rule using source = sg-ec2-lab EC2 role attached /list output showing at least 3 notes

Short answers: 
A) Why is DB inbound source restricted to the EC2 security group? 
B) What port does MySQL use? 
C) Why is Secrets Manager better than storing creds in code/user-data?

Evidence for Audits / Labs (Recommended Output)

aws ec2 describe-security-groups --group-ids sg-0123456789abcdef0 > sg.json aws rds describe-db-instances --db-instance-identifier mydb01 > rds.json aws secretsmanager describe-secret --secret-id my-db-secret > secret.json aws ec2 describe-instances --instance-ids i-0123456789abcdef0 > instance.json aws iam list-attached-role-policies --role-name MyEC2Role > role-policies.json


####################################################################################################

1) aws ec2 describe-security-groups ... > sg.json
Why it’s needed

Proves your network “doors” (Security Group rules) are correct:

EC2 SG allows 80/5000 (web) and optionally 22 (SSH).

RDS SG allows 3306 only from the EC2 SG (SG-to-SG rule).

This is the #1 reason /init hangs or returns 500.

If removed (what happens)

You lose evidence of why traffic should/shouldn’t flow.

Debugging becomes guesswork:

You won’t quickly see if port 80/5000 is open.

You won’t verify the RDS rule is “EC2 SG → 3306” (least exposure).

2) aws rds describe-db-instances ... > rds.json
Why it’s needed

Proves the database exists and is configured correctly:

Correct engine (MySQL), status = available

PubliclyAccessible = false

Subnet group uses two AZs

Shows endpoint + port used in your secret

If removed (what happens)

You can’t prove DB is private or even ready.

You can’t confirm the real endpoint/port — which can cause your app to fail if the secret is wrong.

3) aws secretsmanager describe-secret ... > secret.json
Why it’s needed

Proves the secret exists and has the right features enabled/disabled:

Name/ARN

Rotation status (RotationEnabled / RotationRules)

Which KMS key (if any)

Does not expose secret value (safe for proof packs).

If removed (what happens)

You can’t prove the app’s SECRET_ID points to something real.

You can’t verify rotation is enabled (or why it’s not).

You lose safe audit evidence that “the secret exists without leaking it.”

4) aws ec2 describe-instances ... > instance.json
Why it’s needed

Proves your app host is configured correctly:

Instance ID, subnet, SGs

Whether it has a public IP (Lab1a public version) OR doesn’t (Bonus A private)

IAM instance profile attached (critical for Secrets Manager + SSM)

If removed (what happens)

You can’t prove the instance has the right role.

You can’t prove it’s in the intended subnet / has expected public/private behavior.

Troubleshooting becomes slower: you’ll miss basics like “wrong subnet” or “no role attached.”

5) aws iam list-attached-role-policies ... > role-policies.json
Why it’s needed

Proves what managed policies are attached to your EC2 role, like:

AmazonSSMManagedInstanceCore (so Session Manager works)

This is part of the “no SSH required” story.

If removed (what happens)

You can’t prove the instance can be managed securely via SSM.

If SSM breaks, you won’t quickly see “policy missing” vs “network issue”.