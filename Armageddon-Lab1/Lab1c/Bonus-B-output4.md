
Outputs:

bonus_a_private_ec2_instance_id = "i-08815964229541e03"
bonus_a_vpce_logs_id = "vpce-074aeb053458d3c19"
bonus_a_vpce_s3_id = "vpce-096f9427a8e12a363"
bonus_a_vpce_secrets_id = "vpce-001f386f84b5900c5"
bonus_a_vpce_ssm_id = "vpce-09d514e3ed915becd"
bonus_b_alb_dns_name = "ceklab1-alb-882110808.us-east-1.elb.amazonaws.com"
bonus_b_app_fqdn = "www.keyescloudsolutions.com"
bonus_b_fqdn = "www.keyescloudsolutions.com"
bonus_b_waf_arn = "arn:aws:wafv2:us-east-1:557690581423:regional/webacl/ceklab1-waf/2a531f8d-ceea-4636-9cb9-be2ad2db30e9"
ceklab1_ec2_instance_id = "i-0782e10ad1c02df54"
ceklab1_log_group_name = "/aws/ec2/ceklab1-rds-app"
ceklab1_private_subnet_ids = [
  "subnet-058158d24ac9900f4",
  "subnet-0b61b1986b47bbaf5",
]
ceklab1_public_subnet_ids = [
  "subnet-0090ae5b2b100f83b",
  "subnet-0f2a565b340677980",
]
ceklab1_rds_endpoint = "ceklab1-rds01.cs3cu6i6843p.us-east-1.rds.amazonaws.com"
ceklab1_sns_topic_arn = "arn:aws:sns:us-east-1:557690581423:ceklab1-db-incidents"
ceklab1_vpc_id = "vpc-0c28cc9bd524568eb"

#####################################################################################


Outputs:

bonus_a_private_ec2_instance_id = "i-08815964229541e03"
bonus_a_vpce_logs_id = "vpce-074aeb053458d3c19"
bonus_a_vpce_s3_id = "vpce-096f9427a8e12a363"
bonus_a_vpce_secrets_id = "vpce-001f386f84b5900c5"
bonus_a_vpce_ssm_id = "vpce-09d514e3ed915becd"
bonus_b_alb_dns_name = "ceklab1-alb-882110808.us-east-1.elb.amazonaws.com"
bonus_b_app_fqdn = "www.keyescloudsolutions.com"
bonus_b_fqdn = "www.keyescloudsolutions.com"
bonus_b_waf_arn = "arn:aws:wafv2:us-east-1:557690581423:regional/webacl/ceklab1-waf/2a531f8d-ceea-4636-9cb9-be2ad2db30e9"
ceklab1_ec2_instance_id = "i-0782e10ad1c02df54"
ceklab1_log_group_name = "/aws/ec2/ceklab1-rds-app"
ceklab1_private_subnet_ids = [
  "subnet-058158d24ac9900f4",
  "subnet-0b61b1986b47bbaf5",
]
ceklab1_public_subnet_ids = [
  "subnet-0090ae5b2b100f83b",
  "subnet-0f2a565b340677980",
]
ceklab1_rds_endpoint = "ceklab1-rds01.cs3cu6i6843p.us-east-1.rds.amazonaws.com"
ceklab1_sns_topic_arn = "arn:aws:sns:us-east-1:557690581423:ceklab1-db-incidents"
ceklab1_vpc_id = "vpc-0c28cc9bd524568eb"
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1c$ ws route53 list-resource-record-sets --hosted-zone-id Z0247703397I0ACTR7D96
bash: ws: command not found
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1c$ aws route53 list-resource-record-sets --hosted-zone-id Z0247703397I0ACTR7D96
{
    "ResourceRecordSets": [
        {
            "Name": "keyescloudsolutions.com.",
            "Type": "NS",
            "TTL": 172800,
            "ResourceRecords": [
                {
                    "Value": "ns-1056.awsdns-04.org."
                },
                {
                    "Value": "ns-382.awsdns-47.com."
                },
                {
                    "Value": "ns-1819.awsdns-35.co.uk."
                },
                {
                    "Value": "ns-934.awsdns-52.net."
                }
            ]
        },
        {
            "Name": "keyescloudsolutions.com.",
            "Type": "SOA",
            "TTL": 900,
            "ResourceRecords": [
                {
                    "Value": "ns-1056.awsdns-04.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
                }
            ]
        },
        {
            "Name": "_4e80b6daf0afd9caa0f268e2f005e8c1.www.keyescloudsolutions.com.",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [
                {
                    "Value": "_32c0817cda6bd25ca1f410dfdd20243f.jkddzztszm.acm-validations.aws."
                }
            ]
        }
    ]
}

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Armageddon-Lab1/Lab1c$ ls -la modules/bonus_g_bedrock/lambda/lambda_ir_reporter.zip
-rw-r--r-- 1 chuck 197121 3727 Jan 22 17:34 modules/bonus_g_bedrock/lambda/lambda_ir_reporter.zip
