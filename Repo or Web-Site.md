
## 🧠 Big-picture recommendation (what recruiters actually like)

|Audience|What they click first|What they expect|
|---|---|---|
|Hiring manager|**Website**|Clear story, diagrams, screenshots, outcomes|
|Senior engineer|**Repo**|Terraform quality, structure, naming, modules|
|Auditor / grader|**Evidence pack**|Reproducible artifacts, logs, outputs|

So you don’t choose **Repo OR Website** — you **assign them roles**.

---

## ✅ What goes where (very important)

### 1️⃣ GitHub Repo (authoritative, technical, immutable)

This is where your labs _live_.

**What belongs in the repo**

- Terraform code (modules, root configs)
    
- `terraform plan` success (screenshots or text output)
    
- `README.md` explaining:
    
    - Architecture
        
    - Regions
        
    - Why decisions were made
        
- Diagrams (`draw.io`, PNG exports)
    
- **Evidence scripts** (like your Malgus Python collector)
    
- Sample outputs (`outputs.tf` + sample run)
    

**What does NOT belong**

- Secrets
    
- Long narrative essays
    
- Marketing language
    

📌 Think: _“Could another engineer run this?”_

---

### 2️⃣ Website (portfolio / storytelling layer)

This is what people **read first**.

**What belongs on the website**

- Lab overview (1 page per lab)
    
- Architecture diagram
    
- “What problem this lab solves”
    
- Screenshots from:
    
    - AWS console
        
    - GCP console
        
    - Terraform plan success
        
- Key results (bullets)
    
- **Links back to the repo**
    

📌 Think: _“Could a non-expert understand why this matters?”_

---

## 🧪 Where each Lab fits

### 🔹 Lab 1c (foundations)

**Website**

- Simple page: VPCs, subnets, routing
    
- One diagram
    
- One `terraform plan` screenshot
    

**Repo**

- Clean Terraform structure
    
- Naming discipline
    
- README: “This is the foundation for later labs”
    

---

### 🔹 Lab 3 (cross-region / compliance)

**Website**

- Strong storytelling
    
- “Tokyo = data authority”
    
- “São Paulo / NY = compute only”
    
- Compliance angle
    

**Repo**

- Split state
    
- Modules
    
- Evidence scripts
    
- CloudTrail / logging references
    

---

### 🔹 Lab 4 (multi-cloud, platform-grade)

**Website**

- Flagship lab
    
- Architecture hero diagram
    
- Bullet list of guarantees:
    
    - Data residency
        
    - Private ingress
        
    - Auditability
        

**Repo**

- Best code quality
    
- Reusable modules
    
- Variables well-documented
    
- Python evidence automation
    

---

## 🏆 The winning structure (copy this)

### GitHub

github.com/ChuckKeyes/Armageddon-Labs
├── lab1c/
├── lab3/
├── lab4/
│   ├── terraform/
│   ├── modules/
│   ├── evidence/
│   ├── diagrams/
│   └── README.md




### Website

portfolio.keyescloudsolutions.com
├── labs/
│   ├── lab1c/
│   ├── lab3/
│   └── lab4/




Each website page has:

- Diagram
    
- 5–7 bullets
    
- Screenshots
    
- **“View Terraform on GitHub →”**
    

---

## 🔥 Why this combo wins interviews

- Repo proves **you can execute**
    
- Website proves **you can communicate**
    
- Evidence scripts prove **you understand audits & reality**
    
- Terraform plan passing proves **discipline**
    

This is **exactly** how senior cloud engineers present work.