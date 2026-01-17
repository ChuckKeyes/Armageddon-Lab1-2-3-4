# **Lab 3A — Execution Outline & Correct Order**

> **Principle:**  
> _Data authority first. Network second. Compute last. Verification always._

You **do not** build regions in parallel.  
You build **Tokyo first**, then **São Paulo consumes Tokyo’s outputs**.

---

## **PHASE 0 — Pre-Flight (Do This Before Any Terraform)**

### 0.1 Define CIDR Strategy (Write This Down)

You must lock CIDRs **before** touching Terraform.

Example (you can adjust, but don’t overlap):

- **Tokyo VPC:** `10.10.0.0/16`
    
- **São Paulo VPC:** `10.20.0.0/16`
    

Why this matters:

- TGW routing
    
- Security group rules
    
- Audit clarity
    
- Zero rework later
    

---

### 0.2 Repository & State Structure

Create the structure **now**, even if files are empty.

`lab-3/ ├── tokyo/ │   ├── main.tf │   ├── variables.tf │   ├── outputs.tf │   └── terraform.tfstate (local or remote backend) │ ├── saopaulo/ │   ├── main.tf │   ├── variables.tf │   ├── data.tf │   └── terraform.tfstate`

**Rule:**  
👉 No resource in São Paulo may exist that depends on something not yet output by Tokyo.

---

## **PHASE 1 — Tokyo (Primary / Data Authority Region)**

📍 **Region:** `ap-northeast-1`

This region is the **source of truth**. Everything else depends on it.

---

### 1.1 Deploy Lab 2 Stack (Unmodified First)

Deploy **exactly** what worked in Lab 2:

- VPC
    
- Subnets
    
- ALB
    
- EC2 / ASG
    
- RDS
    
- IAM
    
- Logging
    

✅ **Confirm before proceeding:**

- App works locally in Tokyo
    
- RDS reachable from Tokyo app tier
    
- No public DB access
    

---

### 1.2 Add Transit Gateway (Tokyo = Hub)

Now extend Tokyo.

Create:

- **Transit Gateway**
    
- **TGW Route Table**
    
- **VPC Attachment (Tokyo VPC → TGW)**
    

No peering yet.

---

### 1.3 Prepare for São Paulo (But Don’t Connect It Yet)

Add **placeholders**:

- TGW route table ready for São Paulo CIDR
    
- Security group rule allowing **São Paulo CIDR** → RDS (CIDR only, no SG reference)
    

You are preparing the corridor, not opening it yet.

---

### 1.4 Create TGW Peering Request (Tokyo → São Paulo)

From **Tokyo**:

- Create **TGW peering request**
    
- Target region: `sa-east-1`
    

This is the **only correct direction**:

> Data authority requests access — not the other way around.

---

### 1.5 Export Outputs (Critical)

Tokyo must expose **only what São Paulo is allowed to know**.

`outputs.tf` should include:

- Tokyo VPC CIDR
    
- Tokyo TGW ID
    
- Tokyo TGW Route Table ID
    
- RDS endpoint (hostname only)
    

🚨 **Never expose secrets or credentials via outputs.**

---

## **PHASE 2 — São Paulo (Compute-Only Region)**

📍 **Region:** `sa-east-1`

This region **consumes Tokyo**, never replaces it.

---

### 2.1 Read Tokyo Remote State

In `saopaulo/data.tf`:

- Reference Tokyo’s Terraform state
    
- Import:
    
    - Tokyo VPC CIDR
        
    - Tokyo TGW ID
        
    - RDS endpoint
        

If this fails — **stop**.  
You don’t build blind.

---

### 2.2 Deploy São Paulo VPC (No Database)

Create:

- VPC
    
- Subnets
    
- Routing
    
- Security groups
    

🚫 **Explicitly do NOT create:**

- RDS
    
- Read replicas
    
- Any persistent PHI storage
    

---

### 2.3 Deploy Application Tier Only

Reuse Lab 2 app code, but:

- Point DB connection string to **Tokyo RDS**
    
- Disable any local caching of records
    
- Treat instances as disposable
    

If São Paulo is destroyed, **nothing is lost**.

---

### 2.4 Create São Paulo Transit Gateway

Create:

- São Paulo TGW
    
- TGW Route Table
    
- Attach São Paulo VPC → TGW
    

---

### 2.5 Accept TGW Peering (From Tokyo)

From São Paulo:

- Accept the TGW peering request
    
- Associate TGW route tables
    

This is the **moment the corridor opens**.

---

### 2.6 Add Routes (Both Sides)

You now add routes **symmetrically**:

**São Paulo TGW routes**

- Tokyo CIDR → TGW Peering
    

**Tokyo TGW routes**

- São Paulo CIDR → TGW Peering
    

If either side is missing → traffic fails (by design).

---

## **PHASE 3 — Global Entry Point (CloudFront)**

### 3.1 Create Single Global Distribution

CloudFront:

- One distribution
    
- One DNS name: `chewbacca-growls.com`
    
- Origins:
    
    - Tokyo ALB
        
    - São Paulo ALB
        
- Health checks determine routing
    

---

### 3.2 Enforce Compliance Controls

CloudFront config:

- TLS termination
    
- WAF enabled
    
- Cache only static assets
    
- `Cache-Control: no-store` for PHI endpoints
    

CloudFront **never** stores patient data.

---

## **PHASE 4 — Verification & Proof (This Is Mandatory)**

### 4.1 Functional Proof

From São Paulo EC2:

- Connect to Tokyo RDS
    
- Read/write records
    
- Confirm latency but success
    

---

### 4.2 Structural Proof

In AWS Console:

- TGW attachments visible in both regions
    
- TGW peering status = available
    
- Route tables show cross-region CIDRs
    

---

### 4.3 Compliance Proof

Demonstrate:

- No RDS in São Paulo
    
- No snapshots or backups outside Tokyo
    
- No PHI cached at edge
    
- All access logged
    

---

## **PHASE 5 — Explain It (Senior Skill Check)**

You should be able to say:

> “We separated data authority from compute locality.  
> Tokyo owns persistence. São Paulo provides access.  
> Transit Gateway creates a controlled, auditable corridor.  
> CloudFront delivers global access without global storage.”

If you can explain **why each restriction exists**, you pass.

---

## **Correct Build Order (One-Line Summary)**

**Tokyo core → Tokyo TGW → Outputs → São Paulo VPC → São Paulo app → São Paulo TGW → Peering → Routes → CloudFront → Verification**
