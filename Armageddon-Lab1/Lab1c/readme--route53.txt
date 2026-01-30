/hostedzone/Z0247703397I0ACTR7D96

aws route53 list-hosted-zones-by-name --dns-name keyescloudsolutions.com
dig NS keyescloudsolutions.com +short


aws route53 change-resource-record-sets --hosted-zone-id /hostedzone/Z0247703397I0ACTR7D96 --change-batch '{
  "Comment": "ACM validation for www.keyescloudsolutions.com",
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "_4e80b6daf0afd9caa0f268e2f005e8c1.www.keyescloudsolutions.com",
      "Type": "CNAME",
      "TTL": 300,
      "ResourceRecords": [{
        "Value": "_32c0817cda6bd25ca1f410dfdd20243f.jkddzztszm.acm-validations.aws"
      }]
    }
  }]
}'

aws route53 list-hosted-zones-by-name --dns-name keyescloudsolutions.com

aws acm describe-certificate --region us-east-1 \
  --certificate-arn "arn:aws:acm:us-east-1:557690581423:certificate/213ab199-9e4a-4a76-ba42-1611eb4e9915" \
  --query "Certificate.Status" --output text

3) Prevent this from happening again (important)

You have two hosted zones for the same domain. Your live zone is Z0247703397I0ACTR7D96, so make sure Terraform uses that zone id.

Quick check in your Terraform vars:

route53_zone_id = "Z0247703397I0ACTR7D96"

And later, delete the unused hosted zone (Z019799428OD5TXGX94OO) once you’re sure nothing depends on it.

If you paste the ACM status output, I’ll tell you if you’re clear to re-run terraform apply immediately.

Public entry point (Bonus B):

ALB DNS: ceklab1-alb-1241225782.us-east-1.elb.amazonaws.com

Your public FQDN: www.keyescloudsolutions.com (this should now resolve to the ALB)

WAF is attached (Bonus B):

WAF ARN: arn:aws:wafv2:us-east-1:...:webacl/ceklab1-waf/...

Core app + DB:

App EC2: i-0fe830b239905ab9d

RDS endpoint: ceklab1-rds01.cs3cu6i6843p.us-east-1.rds.amazonaws.com

Bonus A private build:

Private EC2: i-06a1b8677cc49e436

VPC endpoints created (SSM / Secrets / S3 / Logs)

Networking + monitoring:

VPC: vpc-00d7cdb4b3dce159a

CloudWatch log group: /aws/ec2/ceklab1-rds-app

SNS topic: ceklab1-db-incidents