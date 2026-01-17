
---

## AWS Console — Tokyo (ap-northeast-1)

### VPC (Networking)

- **VPC** for Tokyo medical center (your lab VPC)    
- **2+ subnets** (often “app/private” + “db/private” or similar)    
- **Route tables** that show where traffic goes (often to IGW/NAT _or_ to VPN/TGW if you built the corridor)    

Where to look:
- VPC → _Your VPCs_, _Subnets_, _Route Tables_    

### RDS (Database)

- **1 RDS DB instance** in Tokyo (this is your “PHI stays in Japan” proof)    
- **Subnet group** tied to your DB subnets    
- **Security group** allowing DB access only from your allowed CIDRs (like the ones you set)
    

Where to look:

- RDS → _Databases_    
- RDS → _Subnet groups_    
- EC2 → _Security Groups_    

### Security / Audit

- **Security Groups**: DB SG has inbound rules scoped tight (not `0.0.0.0/0`)    
- **CloudTrail** (if enabled): shows recent API activity (“who changed what” evidence)    

Where to look:

- EC2 → _Security Groups_    
- CloudTrail → _Event history_    

### Optional (only if your Lab4 includes it)

- **Transit Gateway** (TGW), **VPN Connections**, **Customer Gateways**    
- **Attachments** and routing that prove “corridor” design    

Where to look:
- VPC → _Transit Gateways_, _VPN Connections_, _Customer Gateways_
    

---

## GCP Console — “NY” side (your US environment)

_(In GCP, “New York” usually means you picked an east region like `us-east1`/`us-east4`. Your script calls it “ny”; the console will show the actual region name.)_

### Compute / App Layer

- **Managed Instance Group (MIG)** in your chosen region    
- Instances created by the MIG (often auto-named)    
- Instance template (startup script, tags, service account)    

Where to look:

- Compute Engine → _Instance groups_    
- Compute Engine → _VM instances_ (you’ll see MIG members)    
- Compute Engine → _Instance templates_    

### Load Balancing (Internal / Private)

If you built the “private only” design:

- **Forwarding rule** that is **Internal Managed** (regional)    
- **Private IP** for the LB (not public)    
- **Backend service** pointing to the MIG    
- **Health check** (HTTP/HTTPS) showing healthy backends    

Where to look:

- Network services → _Load balancing_      (or Compute Engine → _Forwarding rules_, _Backend services_, _Health checks_)    

### Networking / Security

- **VPC network** for NY side    
- **Firewall rules** that show only specific source ranges can reach 443/80 (ex: VPN corridor CIDRs)    
- If you did VPN/BGP:    
    - **Cloud VPN tunnels**        
    - **Cloud Router** with BGP peers (and learned routes)        

Where to look:

- VPC network → _VPC networks_, _Firewall_    
- Hybrid Connectivity → _VPN_    
- Hybrid Connectivity → _Cloud Routers_    

---

## GCP Console — Iowa side (us-central1)

This is where your lab can show “central hub” or “another region” behavior.
Typical things you’ll see (depending on your design):
### Networking Hub / Connectivity

- **Cloud VPN** tunnels in `us-central1` (if Iowa is your hub region)    
- **Cloud Router** in `us-central1` for BGP    
- **Routes** that appear dynamically (learned) if BGP is working    

Where to look:

- Hybrid Connectivity → _VPN_    
- Hybrid Connectivity → _Cloud Routers_    
- VPC network → _Routes_    

### Workloads (if you deployed compute there too)

- A second **MIG**, or    
- Utility VMs (jump box, test VM, router VM), or    
- Nothing compute-related (if it’s only networking)    

Where to look:

- Compute Engine → _VM instances_    
- Compute Engine → _Instance groups_    

---

## What should be visible on _both_ consoles (your “proof pattern”)

### AWS + GCP both show:

- **Networks/subnets** exist (VPC in AWS; VPC network/subnets in GCP)    
- **Firewall/security rules** are restrictive (least privilege)    
- **Routing evidence** exists (route tables in AWS; routes in GCP)    
- **Audit logs** exist (CloudTrail on AWS; Cloud Logging/Audit Logs on GCP if enabled)    

---

## Screenshot checklist (fast “evidence pack”)

If you want the cleanest “grader/auditor proof” screenshots:
### AWS Tokyo

1. RDS database page showing region + DB identifier    
2. DB security group inbound rules
    
3. Route table(s) for the app subnets    
4. TGW/VPN page (if used)    

### GCP NY region

1. MIG list showing desired/current size    
2. Internal LB forwarding rule showing **private IP** + “Internal Managed”    
3. Backend service showing healthy backends    
4. Firewall rule allowing 443 only from corridor CIDRs    

### GCP Iowa (us-central1)

1. VPN tunnels list + status    
2. Cloud Router BGP peers (if configured)    
3. Routes page showing learned routes (if BGP)