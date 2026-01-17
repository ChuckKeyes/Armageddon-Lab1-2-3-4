
## What you already have (enough to verify + run the app)

- **User-data script** that installs Flask + PyMySQL + boto3 and runs the Notes app as a systemd service.
    
    1a_user_data
    
- **Verification CLI** to prove: secret exists, role attached, role can read secret, DB not public, SG-to-SG rule exists, etc.
    
- **Gate runner instructions** that create JSON evidence and exit codes for grading.
    
    1a_final_check
    
- **Inline IAM policy example** for least-privilege secret read.
    
    1a_inline_policy
    

## What’s missing (if you want “CLI-only, no console clicks”)

Your docs show _how to check things_ with CLI, but they do **not** include the full set of AWS CLI commands to **create** everything from scratch, such as:

1. **Create Security Groups + rules** (EC2 SG inbound 80; RDS SG inbound 3306 _from EC2 SG_).
    
2. **Create DB subnet group** (private subnets) if you’re not using defaults.
    
3. **Create the RDS instance** via CLI (`aws rds create-db-instance ...`) and wait for `available`.
    
4. **Create the secret** via CLI (or console): the walkthrough assumes console flow “Credentials for RDS database.”
    
    1a_lab_a_walkthru
    
5. **Create IAM Role + Instance Profile** via CLI:
    
    - `aws iam create-role`
        
    - `aws iam put-role-policy` (using your inline JSON)
        
    - `aws iam create-instance-profile`
        
    - `aws iam add-role-to-instance-profile`
        
6. **Attach the instance profile to EC2** via CLI (`aws ec2 associate-iam-instance-profile`), _or_ launch the instance with it.
    
7. **Gate script files themselves**: your `1a_final_check.txt` references `gate_secrets_and_role.sh`, `gate_network_db.sh`, `run_all_gates.sh` — but those scripts are **not in the uploads you showed me** (so they must be in the instructor repo).
    
    1a_final_check
    

## Bottom line

- **Console + bash commands = enough to complete the lab.** The walkthrough is explicitly console-first for creation, then CLI for proof.
    
- If you want **CLI-only provisioning**, you’re missing the “create” commands listed above **and** you need the actual `gate_*.sh` files from the repo (since the final check expects them).
    
    1a_final_check