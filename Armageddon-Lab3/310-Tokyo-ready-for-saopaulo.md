What you should “feel” conceptually (the words that stick)

The compliance truth
    PHI storage stays in Tokyo
    Compute can move
    Access can be global
    Storage cannot

The engineering truth
    TGW makes a controlled corridor
    CloudFront keeps a single URL
    São Paulo is stateless
    Tokyo is authoritative

That’s the whole lab.
    ....for now....  you can always be a man.....

Quick verification commands (so they can prove it)
From São Paulo EC2 (SSM session)

Test network reachability to Tokyo RDS:

    nc -vz <tokyo-rds-endpoint> 3306

Then app-level verification:
  submit record in São Paulo
  confirm it appears when calling the Tokyo region (same data, one DB)

Confirm routes (AWS CLI)
For each region, verify route tables include the cross-region CIDR to TGW:

    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=<VPC_ID>" --query "RouteTables[].Routes[]"

Suggested structure for the student repo
/tokyo/ = “Lab2 + marginal TGW hub code”
/saopaulo/ = “Lab2 minus DB + TGW spoke code”

  outputs.tf in Tokyo exports:
      tokyo_vpc_cidr
      tokyo_tgw_id
      tokyo_rds_endpoint

São Paulo consumes those outputs (remote state) to configure routes and SG rules

#################################################################################################

Lab 3A — TGW Between Tokyo + São Paulo (RDS in Tokyo Only)
Key reality check (important)

Transit Gateway is regional.
So you don’t “attach São Paulo VPC to Tokyo TGW” directly.
You do this instead:
    TGW in Tokyo
    TGW in São Paulo
    TGW Peering Attachment between them
    Each VPC attaches to its local TGW
    Routes propagate across the peering
    
That’s the correct enterprise pattern.

1) How should São Paulo Terraform change once TGW is established?
What São Paulo removes (from Lab 2)
São Paulo does NOT deploy:
    RDS
    RDS subnet group
    RDS SG rules for local DB
    Any “DB in-region” alarms that assume local DB connectivity

What São Paulo adds (new for Lab 3A)
São Paulo adds:
  A. A new VPC (same Lab 2 structure: public/private, NAT, ALB, ASG, CloudFront origin header rules)
  B. A Transit Gateway (sa-east-1) and VPC attachment
  C. Routes:
    São Paulo private subnets route Tokyo VPC CIDR → São Paulo TGW
  D. Optionally: Secrets Manager replica / Parameter Store copies of DB endpoint (credentials aren’t PHI; still keep tight controls)

The main code changes are routing + TGW attachment. Everything else is basically “Lab 2 but no DB.”

2) How does São Paulo EC2 connect with Tokyo RDS?
São Paulo EC2 connects to Tokyo RDS like it’s “another subnet,” but across AWS backbone:

Network path
    São Paulo EC2 (private subnet)
    → São Paulo VPC route table: Tokyo-VPC-CIDR → TGW-SP
    → TGW Peering → TGW Tokyo
    → Tokyo VPC attachment
    → Tokyo private subnet route table sends return traffic back via TGW
    → RDS private IP reachable

Security group rules (critical)
Because SG referencing doesn’t work across VPCs the way people hope, the simplest correct pattern is:
    Tokyo RDS SG allows inbound 3306 from São Paulo VPC CIDR (or from a dedicated SP app subnet CIDR)
    São Paulo EC2 SG allows outbound to Tokyo RDS on 3306

Also ensure:
    VPC DNS resolution is enabled (it is by default in most lab VPCs)
    RDS endpoint resolves to a private IP in Tokyo VPC (which your São Paulo instances can reach via TGW)

3) How would São Paulo connect with Tokyo Transit Gateway?
This is the actual TGW wiring:
In Tokyo (minimal “marginal TF code”)
    Tokyo TGW exists (or you create it)
    Tokyo TGW attaches to Tokyo VPC
    Tokyo TGW creates peering attachment request to São Paulo TGW

In São Paulo (new TF)
    Create São Paulo TGW
    Accept TGW peering attachment
    Attach São Paulo VPC to São Paulo TGW
    Add routes in São Paulo VPC route tables pointing Tokyo CIDR → São Paulo TGW
    Add routes in Tokyo VPC route tables pointing São Paulo CIDR → Tokyo TGW

That’s it: attachments + routes + SG rules.

Naming Convention Theme
Tokyo names: train stations
Examples:
    shinjuku-* 新宿
    shibuya-*　　渋谷
    ueno-*　上野
    akihabara-* 秋葉原
    tokyo-*　東京

    São Paulo names: Japanese-town-related

Use the Japanese district:
  liberdade-* (perfeita)
  optionally: bairro-liberdade-*, praca-liberdade-*

I’d standardize:
  Tokyo prefix: shinjuku
  São Paulo prefix: liberdade

So students can immediately “feel” the region.  Maybe hard for you, easy for Darth Malgus.

Terraform Blueprint (High-signal skeleton)
A) Providers (multi-region)---> Folder provider.tf
B) Tokyo (minimal additions) — TGW + peering request---> Folder tokyo_tgw.tf
    (Tokyo already has Lab 2 infra + RDS.)
C) São Paulo (new deployment) — TGW + accept peering + attach VPC---> Folder sao_paulo_tgw.tf
    (São Paulo is “Lab 2 minus DB”, plus TGW wiring.)
D) Routes (the “it works or it doesn’t” part)
    São Paulo route tables --> sao_paulo_routes.tf
        Add in private subnet route tables:  
            Destination: Tokyo VPC CIDR (e.g., 10.x.x.x/xx)
            Target: São Paulo TGW
    Tokyo route tables---> Tokyo_routes.tf
        Add in Tokyo private route tables:
            Destination: São Paulo VPC CIDR
            Target: Tokyo TGW
E) RDS Security Group change in Tokyo (allows São Paulo)---> aws_security_group.chewbacca_rds_sg01.tf
    This is the part students always forget because they are stuck in waffle house with them carbs:

############################################################################################

Lab 3A — Japan Medical
Cross-Region Architecture with Transit Gateway (APPI-Compliant)

🎯 Lab Objective
In this lab, you will design and deploy a cross-region medical application architecture that:
  Uses two AWS regions
    Tokyo (ap-northeast-1) — data authority
    São Paulo (sa-east-1) — compute extension
  Connects regions using AWS Transit Gateway
  Serves traffic through a single global URL
  Stores all patient medical data (PHI) only in Japan
  Allows doctors overseas to read/write records legally

This lab is a warm-up for real DevOps and platform engineering, where:
  environments are separated
  Terraform state is split
  pipelines are independent
  coordination matters more than copy-paste

🏥 Real-World Context (Why This Exists)

Japan’s privacy law, 個人情報保護法 (APPI), places strict requirements on the handling of personal and medical data.
For healthcare systems, the safest and most common interpretation is:
    Japanese patient medical data must be stored physically inside Japan. (Don't even mess with this)

This applies even when:
    the patient is traveling abroad
    the doctor is located overseas
    the application is accessed globally

📌 Access is allowed. Storage is not.
    --> This lab models how real medical systems comply with that rule.

🌍 Regional Roles
🇯🇵 Tokyo — Primary Region (Data Authority)
Tokyo is the source of truth.
It contains:
    RDS (medical records)
    Primary VPC
    Application tier (Lab 2 stack)
    Transit Gateway (hub)
    Parameter Store & Secrets Manager (authoritative)
    Logging, auditing, backups
    Really hot chicks who need men to impregnate them. 

All data at rest lives here.
If Tokyo is unavailable:
    the system may degrade
    but data residency is never violated

This is intentional and correct.

🇧🇷 São Paulo — Secondary Region (Compute-Only)

São Paulo exists to serve doctors and staff physically located in South America.

It contains:
    VPC
    EC2 + Auto Scaling Group
    Application tier (Lab 2 stack)
    Transit Gateway (spoke)
    Even hotter chicks who need you to throw it down and impregnate them.

It does not contain:
    RDS
    Read replicas
    Backups
    Persistent storage of PHI
    Keisha. No Keisha here.

São Paulo is stateless compute.<----> All reads and writes go directly to Tokyo.

🌐 Networking Model
Why Transit Gateway?
Transit Gateway is used instead of VPC peering because it provides:
    Clear, auditable traffic paths
    Centralized routing control
    Enterprise-grade segmentation
    A visible “data corridor” for compliance reviews

In regulated environments, clarity beats convenience.

How Traffic Flows

Doctor (São Paulo)
   ↓
CloudFront (global edge)
   ↓
São Paulo EC2 (stateless)
   ↓
Transit Gateway (São Paulo)
   ↓
TGW Peering
   ↓
Transit Gateway (Tokyo)
   ↓
Tokyo VPC
   ↓
Tokyo RDS (PHI stored here only)
The entire path stays on the AWS backbone and is encrypted in transit.

🌐 Single Global URL

There is only one public URL: https://chewbacca-growls.com

CloudFront:
    Terminates TLS
    Applies WAF
    Routes users to the nearest healthy region
    Never stores patient data
    Caches only content explicitly marked safe

CloudFront is allowed because:
    it is not a database
    it does not persist PHI
    it respects cache-control rules

🏗️ Terraform & DevOps Structure
Important: Multi-Terraform-State Reality

In real organizations, regions are not deployed from one Terraform state.

For this lab:
    Tokyo and São Paulo are separate Terraform states
    Each state will eventually map to a separate Jenkins job
    States communicate only through:
        Terraform outputs
        Remote state references
        Explicit variables

This is intentional.---> You are learning how real DevOps teams coordinate infrastructure.

Expected Repository Layout
lab-3/
├── tokyo/
│   ├── main.tf        # Lab 2 + marginal TGW hub code
│   ├── outputs.tf     # Exposes TGW ID, VPC CIDR, RDS endpoint
│   └── variables.tf
│
├── saopaulo/
│   ├── main.tf        # Lab 2 minus DB + TGW spoke code
│   ├── variables.tf
│   └── data.tf        # Reads Tokyo remote state

🚆 Naming Conventions (Important)

To make the architecture feel local and intentional:
Tokyo (train stations)
    shinjuku-*
    shibuya-*
    ueno-*
    akihabara-*

São Paulo (Japanese district)
    liberdade-*

You should be able to look at a resource name and know the region immediately.

🔧 What Changes from Lab 2
Tokyo (minimal changes)
    Add Transit Gateway
    Attach Tokyo VPC to TGW
    Create TGW peering request
    Add return routes for São Paulo CIDR
    Update RDS security group to allow São Paulo VPC CIDR

São Paulo (new deployment)
    Deploy Lab 2 stack without RDS
    Create São Paulo Transit Gateway
    Accept TGW peering
    Attach São Paulo VPC to TGW
    Add routes pointing Tokyo CIDR → TGW

🔐 Security Model (Read Carefully)
  RDS allows inbound only from:
    Tokyo application subnets
    São Paulo VPC CIDR (explicitly)
  No public DB access
  No local PHI storage in São Paulo
  All access is logged and auditable

This is compliance by design, not by policy.

✅ What You Must Prove (Verification)
From a São Paulo EC2 instance:
    You can connect to Tokyo RDS
    The application can read/write records
    No database exists in São Paulo

From the AWS console / CLI:
    TGW attachments exist in both regions
    Route tables contain cross-region CIDRs
    Traffic flows only through TGW

❌ What Is Explicitly Not Allowed
    RDS outside Tokyo
    Cross-region replicas
    Aurora Global Database
    Local caching of patient records
    CloudFront caching PHI
    “Active/active” databases

If you do these, the architecture is illegal, not just “wrong”.

🎓 Why This Lab Matters for Your Career

Most engineers learn:
  “Make it multi-region”
  “Replicate everything”
  "Study CompTia and give my money to Keisha"{

This lab teaches you:
  How law shapes architecture
  How to design asymmetric global systems
  How to explain tradeoffs to security, legal, and auditors
  How DevOps actually works across teams and states
  Become a Passport Bro and marry the girl of your dreams

If you can explain this lab clearly, you are operating at a Senior level.

🗣️ Interview Talk Track (Memorize This)

    “I designed a cross-region medical system where all PHI remained in Japan to comply with APPI.
    Tokyo hosted the database, São Paulo ran stateless compute, and Transit Gateway provided a controlled data corridor.
    CloudFront delivered a single global URL without violating data residency.”

That answer will stop the room.

🧠 One Sentence to Remember---> Global access does not require global storage.
    Anothe Sentence to Remember ---> I completed this lab in 2026 and now in 2029, I have a family.
