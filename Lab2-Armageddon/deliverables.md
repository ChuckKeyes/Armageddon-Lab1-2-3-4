
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

alb_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:557690581423:loadbalancer/app/lab2-vpc-alb/5d5fea8d9bce3897"
alb_cert_arn_tokyo = "arn:aws:acm:ap-northeast-1:557690581423:certificate/e83a9a4d-2c20-49b8-a7a7-de096702abcd"
alb_dns_name = "lab2-vpc-alb-451009432.ap-northeast-1.elb.amazonaws.com"
app_fqdn = "www.keyescloudsolutions.com"
azs = tolist([
  "ap-northeast-1a",
  "ap-northeast-1c",
])
cloudfront_distribution_id = "E3BZLJNQCHJ6H3"
cloudfront_domain_name = "d3ke9svnmp2zff.cloudfront.net"
cloudfront_viewer_cert_arn = "arn:aws:acm:us-east-1:557690581423:certificate/786c5d1d-91ff-402e-ab23-ad6fa7c9496c"
cloudfront_waf_arn = "arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/69896d27-b869-4db0-94da-379e8a30c877"
cloudfront_waf_id = "69896d27-b869-4db0-94da-379e8a30c877"
domain_name = "keyescloudsolutions.com"
igw_id = "igw-0c60aa673ff4f13c6"
origin_header_name = "X-Origin-Verify"
origin_header_value = <sensitive>
private_app_subnet_ids = [
  "subnet-01feedb6c414cc42a",
  "subnet-0a7d40a9c854c5bb1",
]
private_db_subnet_ids = [
  "subnet-0d9650e523e9dd3b8",
  "subnet-0cc8ea657f749c20e",
]
public_subnet_ids = [
  "subnet-0d5915f1a3f44c9bb",
  "subnet-00c765e97c97c5445",
]
rds_endpoint = "lab2-vpc-db.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com"
rds_port = 5432
target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:557690581423:targetgroup/lab2-vpc-tg/c5c659e5d2d25266"
vpc_id = "vpc-0f346555ff0585206"

#####################################################################################

Get the Web ACL (CloudFront scope, us-east-1)

aws wafv2 get-web-acl \
  --name lab2-vpc-cf-waf \
  --scope CLOUDFRONT \
  --id 69896d27-b869-4db0-94da-379e8a30c877 \
  --region us-east-1

  {
    "WebACL": {
        "Name": "lab2-vpc-cf-waf",
        "Id": "69896d27-b869-4db0-94da-379e8a30c877",
        "ARN": "arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/69896d27-b869-4db0-94da-379e8a30c877",
        "DefaultAction": {
            "Allow": {}
        },
        "Description": "CloudFront WAF for lab2-vpc",
        "Rules": [
            {
                "Name": "AWSManagedCommonRuleSet",
                "Priority": 1,
                "Statement": {
                    "ManagedRuleGroupStatement": {
                        "VendorName": "AWS",
                        "Name": "AWSManagedRulesCommonRuleSet"
                    }
                },
                "OverrideAction": {
                    "None": {}
                },
                "VisibilityConfig": {
                    "SampledRequestsEnabled": true,
                    "CloudWatchMetricsEnabled": true,
                    "MetricName": "lab2-vpc-common-rules"
                }
            }
        ],
        "VisibilityConfig": {
            "SampledRequestsEnabled": true,
            "CloudWatchMetricsEnabled": true,
            "MetricName": "lab2-vpc-cf-waf"
        },
        "Capacity": 700,
        "ManagedByFirewallManager": false,
        "LabelNamespace": "awswaf:557690581423:webacl:lab2-vpc-cf-waf:",
        "RetrofittedByFirewallManager": false,
        "OnSourceDDoSProtectionConfig": {
            "ALBLowReputationMode": "ACTIVE_UNDER_DDOS"
        }
    },
    "LockToken": "b2b099dc-bf20-48fd-ae27-47efe31f662f"
}

  ####################################################################################

Confirm the distribution references the WAF

aws cloudfront get-distribution \
  --id E3BZLJNQCHJ6H3 \
  --query "Distribution.DistributionConfig.WebACLId" \
  --output text
  arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/69896d27-b869-4db0-94da-379e8a30c877

  #########################################################################

  dig www.keyescloudsolutions.com A +short
dig www.keyescloudsolutions.com AAAA +short

##################################################################

dig d3ke9svnmp2zff.cloudfront.net A +short
dig d3ke9svnmp2zff.cloudfront.net AAAA +short

#####################################################################################

echo "ALB:  https://lab2-vpc-alb-451009432.ap-northeast-1.elb.amazonaws.com"
echo "APP:  https://www.keyescloudsolutions.com"
echo "CF:   https://d3ke9svnmp2zff.cloudfront.net"
echo "WAF:  arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/69896d27-b869-4db0-94da-379e8a30c877"
echo "CFID: E3BZLJNQCHJ6H3"

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ echo "ALB:  https://lab2-vpc-alb-451009432.ap-northeast-1.elb.amazonaws.com"
ALB:  https://lab2-vpc-alb-451009432.ap-northeast-1.elb.amazonaws.com
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ echo "APP:  https://www.keyescloudsolutions.com"
APP:  https://www.keyescloudsolutions.com
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ echo "CF:   https://d3ke9svnmp2zff.cloudfront.net"
CF:   https://d3ke9svnmp2zff.cloudfront.net
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ echo "WAF:  arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/69896d27-b869-4db0-94da-379e8a30c877"
WAF:  arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/69896d27-b869-4db0-94da-379e8a30c877
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ echo "CFID: E3BZLJNQCHJ6H3"
CFID: E3BZLJNQCHJ6H3