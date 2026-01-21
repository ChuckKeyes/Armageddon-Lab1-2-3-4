What Bonus-B is (architecture)

Route53/Domain points app.yourdomain.com → ALB DNS name (Alias record)

ALB sits in public subnets with an SG that allows 80/443 from the internet

ALB listeners

80 → redirect to 443

443 → forwards to a Target Group

Target Group contains private EC2 instance(s) in private subnets

Private EC2 SG allows port 80 (or 8080) inbound ONLY from the ALB SG

ACM certificate for app.yourdomain.com (must be validated)

Optional but common:

WAFv2 attached to the ALB

CloudWatch alarm on ALB 5XX → SNS email

CloudWatch dashboard for requests/latency/errors

If any of these are missing, the chain breaks.
###################################################################################
The “make it work” checklist (minimum viable Bonus-B)
1) Preconditions (must already exist)

VPC

2 public subnets in different AZs

2 private subnets

IGW + public route table

Private route table (NAT optional but helpful for installs)

A working private EC2 running a web server on a known port (80 is easiest)
###################################################################################

2) ALB Security Group (public)

Inbound:

TCP 80 from 0.0.0.0/0

TCP 443 from 0.0.0.0/0
Outbound:

TCP 80 to the private EC2 SG (or allow all outbound for lab)

3) Private EC2 Security Group rule (from ALB only)

######################################################################################

Inbound TCP 80 source = ALB SG

########################################################################################

4) ALB (public)

internal = false

subnets = your public subnet IDs

SG = ALB SG

##########################################################################################

5) Target Group + Attachment

TG protocol HTTP, port 80

health check path / (or /health)

attach private EC2 instance id and port 80

############################################################################################

6) Listeners

80 redirect to 443

443 forward to TG (needs ACM cert validation done)

###############################################################################################

7) ACM + DNS validation (this is the “hard gate”)

Create ACM certificate for app.<domain>

Create Route53 validation records

Wait until status is ISSUED

Only then will HTTPS listener succeed

#################################################################################################3

8) WAF + Monitoring (after ALB works)

WAF ACL + association to ALB ARN

CloudWatch alarm on ALB 5XX uses LoadBalancer = alb.arn_suffix

Alarm action → SNS topic ARN

######################################################################################################

The 3 biggest “gotchas” that block Bonus-B

ACM cert not validated yet → HTTPS listener fails

ALB in wrong subnets (must be public subnets with route to IGW)

Target health checks failing

private EC2 not running web server

wrong port

EC2 SG doesn’t allow inbound from ALB SG

wrong health check path

What you should do next (fastest path)

#############################################################################################

Step 1: Decide the “app target” instance

You currently have:

Original EC2: i-0f9776514b499db54 (likely public)

Bonus-A private EC2: i-0cfa9b5c37f61942f (private)

For Bonus-B, the target should be the private one:
✅ i-0cfa9b5c37f61942f

(That’s the point: public ALB → private instance.)

#####################################################################################################

Step 2: Use your existing public subnets

From your outputs:

public subnets:

subnet-0c5c956476028bcf2

subnet-020b463b4a1bc3880

Those are exactly what ALB needs.

########################################################################################################

Step 3: Confirm the private EC2 serves HTTP

On that private instance, your app must return 200 on / (or your chosen health path).
If it doesn’t, the ALB will show “unhealthy targets” and you’ll get 503.

Bonus-B in Terraform terms (what files you’ll end up with)

bonus-b-alb-sg.tf

bonus-b-alb.tf (lb + listeners)

bonus-b-tg.tf (tg + attachment)

bonus-b-acm.tf (cert + validation + route53 record)

bonus-b-waf.tf (optional)

bonus-b-monitoring.tf (alarm + dashboard)

One quick note about “Bonus A is shutting down”

If your private EC2 is stopping:

check it’s not Spot

check there’s no shutdown behavior set oddly

check your user_data isn’t calling shutdown

check AWS instance status checks / system log

But Bonus-B works even if you recreate the private EC2; ALB just needs a healthy target.