
> **Iowa & New York = GCP**  
> **Tokyo = AWS (medical data authority)**  
> **All PHI / medical records stay in Tokyo**

This is now a **cross-cloud, compliance-driven hub-and-spoke design**, not a simple TGW demo.

---

## 🧭 Lab 4 (Updated) — **Cross-Cloud Medical Architecture**

**AWS Tokyo (Data Authority) ↔ GCP Iowa & New York (Compute / Access)**

![https://docs.aws.amazon.com/images/prescriptive-guidance/latest/strategy-modern-healthcare-data/images/modern-healthcare-data-strategy.png](https://docs.aws.amazon.com/images/prescriptive-guidance/latest/strategy-modern-healthcare-data/images/modern-healthcare-data-strategy.png)

![https://docs.aws.amazon.com/images/solutions/latest/network-orchestration-aws-transit-gateway/images/network-orchestration-aws-transit-gateway-architecture.png](https://docs.aws.amazon.com/images/solutions/latest/network-orchestration-aws-transit-gateway/images/network-orchestration-aws-transit-gateway-architecture.png)

![https://www.gstatic.com/bricks/image/17c446105477bc5d60848b02d3d2699d53f5dcc6cb56996af0be19d549420831.svg](https://www.gstatic.com/bricks/image/17c446105477bc5d60848b02d3d2699d53f5dcc6cb56996af0be19d549420831.svg)

5

---

## 🎯 Core Compliance Rule (this drives everything)

> **Medical data (PHI) must never leave Tokyo (AWS).**  
> Iowa & New York (GCP) may **process, view, or proxy** data — but **never store it**.

This is **APPI / HIPAA-style data residency**, and every routing decision must enforce it.

---

## 🏗️ Final High-Level Architecture

### 🔴 **AWS (Tokyo) — System of Record**

- **Amazon Web Services**
    
- VPC in `ap-northeast-1`
    
- RDS / Aurora / DB **ONLY here**
    
- **AWS Transit Gateway** = control plane
    
- No inbound public DB access
    
- Only **controlled ingress** from GCP
    

### 🔵 **GCP (Iowa + New York) — Stateless Compute**

- **Google Cloud**
    
- Separate VPCs:
    
    - `gcp-iowa-vpc`
        
    - `gcp-ny-vpc`
        
- App servers, APIs, thin clients
    
- No persistent medical storage
    
- **Google Cloud Network Connectivity Center** = hub
    

---

## 🔑 The Backbone (Most Important Part)

### Connectivity Pattern

`GCP Iowa ─┐           ├─► GCP NCC Hub ─► HA VPN + BGP ─► AWS TGW (Tokyo) GCP NY ───┘`

### Why this works

- **Single choke point** (NCC ↔ TGW)
    
- Explicit routing
    
- Auditable paths
    
- No accidental east-west leaks
    

---

## 🧠 Key Design Decisions (Exam-Level)

### ❌ What you are **NOT** doing

- ❌ No AWS Iowa / NY
    
- ❌ No cross-region AWS replication
    
- ❌ No GCP database
    
- ❌ No mesh peering between clouds
    

### ✅ What you **ARE** doing

- ✅ One **data authority region** (Tokyo)
    
- ✅ Stateless multi-cloud compute
    
- ✅ Explicit backbone routing
    
- ✅ BGP-controlled propagation
    
- ✅ Central inspection point
    

---

## 🧭 Routing Logic (This Is the “Lab 4” Part)

### AWS TGW (Tokyo)

- Routes:
    
    - GCP Iowa CIDR → VPN attachment
        
    - GCP NY CIDR → VPN attachment
        
- **No default route advertised outward**
    
- Only DB subnets are reachable
    

### GCP NCC Hub

- Routes:
    
    - Tokyo DB CIDR → VPN
        
- **No route that allows GCP ↔ GCP via AWS**
    
- Iowa and NY only reach Tokyo
    

---

## 🔐 Data Residency Enforcement (How you prove it)

You will explicitly show:

- RDS SG allows **only VPN CIDRs**
    
- No DB subnet route to internet
    
- GCP subnets have:
    
    - Route to Tokyo DB
        
    - **No route to store data locally**
        
- App code:
    
    - Reads/writes DB over private IP
        
    - No local persistence
        

This is **auditor-ready**.

---

## 🧪 Proof Checklist (What You’ll Screenshot)

### AWS

- TGW attachments
    
- TGW route table (only GCP CIDRs)
    
- RDS in Tokyo
    
- No public DB endpoint
    

### GCP

- NCC hub
    
- Two spokes (Iowa + NY)
    
- HA VPN status (BGP Established)
    
- Routes showing Tokyo CIDR
    

---

## 🧠 One-Sentence Architecture Summary (Gold)

> A single AWS Tokyo region acts as the medical data authority, while Google Cloud Iowa and New York provide stateless compute connected via NCC and BGP-based VPN to AWS Transit Gateway, enforcing strict data residency and explicit routing.

You can use that **verbatim**.

---

## 🔜 How I recommend we build this (next step)

Choose **one** and I’ll start immediately:

1️⃣ **Diagram first** (labels + CIDRs + routing intent)  
2️⃣ **AWS Tokyo TGW + VPC** (CLI, step-by-step)  
3️⃣ **GCP NCC hub + Iowa/NY spokes**  
4️⃣ **BGP + route propagation rules**  
5️⃣ **Failure scenarios (what breaks if misrouted)**