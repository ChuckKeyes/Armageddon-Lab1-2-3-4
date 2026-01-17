
![[Pasted image 20260113123232.png]]

![[Pasted image 20260113123306.png]]


![[Pasted image 20260113123333.png]]

![[Pasted image 20260113123352.png]]
User
  ↓ HTTP
EC2 (App Server)
  ↓ IAM Role (no passwords)
Secrets Manager
  ↓ credentials
RDS (Private DB)


### What You Are Proving

- Databases are **never public**
    
- Apps **never store credentials**
    
- IAM Roles replace static secrets
    
- Security Groups enforce **trust boundaries**
    
- You can **prove** all of this with CLI evidence
    

This is **interview-level infrastructure**, not toy lab work.

---

## 🧠 Mental Model (Read This Once)

There are **5 layers**, and each layer depends on the previous one.

If you build them out of order → you debug forever.

---

## 🧱 Layer 1 — Networking Foundation (DO FIRST)

**Goal:** Make sure traffic _can_ flow — but only where allowed.

### Order

1. **VPC exists**
    
2. **Subnets exist**
    
    - EC2 subnet (public)
        
    - RDS subnet(s) (private)
        
3. **Security Groups**
    
    - `sg-ec2-lab`
        
        - Inbound: HTTP 80 (world)
            
    - `sg-rds-lab`
        
        - Inbound: **MySQL 3306 from sg-ec2-lab ONLY**
            

🚫 Do **NOT**:

- Open 3306 to `0.0.0.0/0`
    
- Make RDS public
    

👉 Until SGs are correct, **nothing else matters**.

---

## 🗄️ Layer 2 — RDS Database (SECOND)

**Goal:** Create a DB that is reachable _only_ by the app server.

### Order

1. Create **RDS MySQL**
    
2. Attach:
    
    - Correct VPC
        
    - Private subnet group
        
    - `sg-rds-lab`
        
3. Verify:
    
    - `PubliclyAccessible = false`
        
    - Endpoint exists
        
    - Status = `available`
        

📌 The DB **does nothing yet** — that’s fine.

---

## 🔐 Layer 3 — Secrets & Identity (THIRD)

**Goal:** Remove passwords from humans, code, and machines.

### Order

1. **Secrets Manager**
    
    - Store RDS credentials
        
    - Use _“Credentials for RDS database”_
        
    - Name: `lab/rds/mysql`
        
2. **IAM Role**
    
    - Trusted entity: EC2
        
    - Permission: `secretsmanager:GetSecretValue`
        
    - Scope to **this secret only**
        
3. **Attach role to EC2 (later)**
    

🧠 This is the **trust contract**:

> EC2 may read _this_ secret, and nothing else.

---

## 🖥️ Layer 4 — EC2 Compute (FOURTH)

**Goal:** Launch compute that has **identity but no secrets**.

### Order

1. Launch EC2
    
    - Same VPC
        
    - `sg-ec2-lab`
        
2. Attach **IAM Role**
    
3. User-data installs:
    
    - Python
        
    - Flask
        
    - boto3
        
    - MySQL client
        
4. App pulls DB creds **at runtime** from Secrets Manager
    

⚠️ If EC2 launches **before** IAM Role or Secret exists → app fails.

---

## 🔁 Layer 5 — Application & Data Flow (LAST)

**Goal:** Prove end-to-end trust works.

### Order

1. Visit:
    
    - `/init` → creates DB + table
        
    - `/add?note=hello`
        
    - `/list`
        
2. Restart EC2
    
3. Refresh `/list`
    

✅ Data persists  
✅ App is stateless  
✅ DB is protected

That’s the **money shot**.

---

## 🧪 Verification Layer — HOW THIS GETS GRADED

![https://k21academy.com/wp-content/uploads/2021/04/verify-key-pair-1.png](https://k21academy.com/wp-content/uploads/2021/04/verify-key-pair-1.png)

![https://user-images.githubusercontent.com/18277423/135340094-090025ce-01e8-479b-acb1-dd5135a6accc.png](https://user-images.githubusercontent.com/18277423/135340094-090025ce-01e8-479b-acb1-dd5135a6accc.png)

![https://media2.dev.to/dynamic/image/width%3D1000%2Cheight%3D420%2Cfit%3Dcover%2Cgravity%3Dauto%2Cformat%3Dauto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Finbwb6151svsussqpm5s.png](https://media2.dev.to/dynamic/image/width%3D1000%2Cheight%3D420%2Cfit%3Dcover%2Cgravity%3Dauto%2Cformat%3Dauto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Finbwb6151svsussqpm5s.png)

You **must** prove with CLI:

- EC2 has an IAM role
    
- Role can read the secret
    
- DB is private
    
- SG uses SG-to-SG rules
    
- App can read/write data
    

This is why the **gate scripts exist** — they simulate an auditor.

---

## 🧩 Final Execution Order (Print This)

`1. VPC + Subnets 2. Security Groups 3. RDS (private) 4. Secrets Manager 5. IAM Role 6. EC2 (attach role) 7. App bootstrap 8. Browser test 9. CLI verification 10. Evidence pack`

If something breaks:

- **Go backward one layer**
    
- Never forward-debug