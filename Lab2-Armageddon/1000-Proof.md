chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ curl -I "https://lab2-vpc-alb-1206537763.ap-northeast-1.elb.amazonaws.com" -k
HTTP/1.1 200 OK
Date: Wed, 25 Feb 2026 20:06:57 GMT
Content-Type: text/html
Content-Length: 266
Connection: keep-alive
Server: nginx/1.28.2
Last-Modified: Wed, 25 Feb 2026 18:21:33 GMT
ETag: "699f3dad-10a"
Accept-Ranges: bytes

####################################################################################################

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ curl -I "https://www.keyescloudsolutions.com"
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 266
Connection: keep-alive
Date: Wed, 25 Feb 2026 20:11:02 GMT
Accept-Ranges: bytes
Server: nginx/1.28.2
Last-Modified: Wed, 25 Feb 2026 18:21:33 GMT
ETag: "699f3dad-10a"
X-Cache: Miss from cloudfront
Via: 1.1 456dd60f1399d8458ed20abe4eae33a0.cloudfront.net (CloudFront)
X-Amz-Cf-Pop: MIA3-P5
X-Amz-Cf-Id: _8zmLaJTO7cJvyu6r6y87KkfctjIIWhBhzbA0zmZ8beIUfTEukmTkw==

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ curl -I "https://keyescloudsolutions.com"
curl: (35) schannel: next InitializeSecurityContext failed: SEC_E_ILLEGAL_MESSAGE (0x80090326) - This error usually occurs when a fatal SSL/TLS alert is received (e.g. handshake failed). More detail may be available in the Windows System event log.

#########################################################################################################

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ aws wafv2 get-web-acl \
>   --name lab2-vpc-cf-waf \
>   --scope CLOUDFRONT \
>   --id 2de79645-7537-42a9-9112-54e670d216ff \
>   --region us-east-1
{
    "WebACL": {
        "Name": "lab2-vpc-cf-waf",
        "Id": "2de79645-7537-42a9-9112-54e670d216ff",
        "ARN": "arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/2de79645-7537-42a9-9112-54e670d216ff",
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
    "LockToken": "9765596b-9dea-4786-96ab-0d73d12938db"
}

#################################################################################

aws cloudfront get-distribution \
  --id E8BUJ21RWI4E8 \
  --query "Distribution.DistributionConfig.WebACLId"
  "arn:aws:wafv2:us-east-1:557690581423:global/webacl/lab2-vpc-cf-waf/2de79645-7537-42a9-9112-54e670d216ff"

  ###################################################################################

  nslookup www.keyescloudsolutions.com
nslookup keyescloudsolutions.com

Name:    www.keyescloudsolutions.com
Addresses:  2600:9000:2502:3c00:1a:e922:eb40:93a1
Addresses:  2600:9000:2502:3c00:1a:e922:eb40:93a1
Addresses:  2600:9000:2502:3c00:1a:e922:eb40:93a1
          2600:9000:2502:3000:1a:e922:eb40:93a1
          2600:9000:2502:f000:1a:e922:eb40:93a1
          2600:9000:2502:1000:1a:e922:eb40:93a1
          2600:9000:2502:7e00:1a:e922:eb40:93a1
          2600:9000:2502:a000:1a:e922:eb40:93a1
          2600:9000:2502:6a00:1a:e922:eb40:93a1
          2600:9000:2502:f800:1a:e922:eb40:93a1
          13.249.96.25
          13.249.96.126
          13.249.96.117
          13.249.96.19

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab2-Armageddon$ nslookup keyescloudsolutions.com
Server:  cdns01.comcast.net
Address:  75.75.75.75

Non-authoritative answer:
Name:    keyescloudsolutions.com
Addresses:  2600:9000:2502:ca00:1a:e922:eb40:93a1
          2600:9000:2502:c400:1a:e922:eb40:93a1
          2600:9000:2502:da00:1a:e922:eb40:93a1
          2600:9000:2502:ac00:1a:e922:eb40:93a1
          2600:9000:2502:5200:1a:e922:eb40:93a1
          2600:9000:2502:6600:1a:e922:eb40:93a1
          2600:9000:2502:f400:1a:e922:eb40:93a1
          2600:9000:2502:6e00:1a:e922:eb40:93a1
          13.249.96.19
          13.249.96.126
          13.249.96.117
          13.249.96.25