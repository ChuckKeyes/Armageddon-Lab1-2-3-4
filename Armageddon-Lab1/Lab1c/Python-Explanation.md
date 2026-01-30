What each file does
1) claude.py — tiny “call Bedrock Claude” helper

Creates a bedrock-runtime client and sends a request using Anthropic’s Bedrock message format.

Returns the model’s text output (joins text parts).
Use-case: ad-hoc prompts (summarize evidence, explain logs, draft reports) from your terminal or another script. 

claude

2) handler.py — Lambda “Incident Report Generator”

This is the real automation brain:

Reads required config from environment variables:

REPORT_BUCKET, APP_LOG_GROUP, WAF_LOG_GROUP, SECRET_ID, SSM_PARAM_PATH, BEDROCK_MODEL_ID, SNS_TOPIC_ARN 

handler

Pulls:

SSM Parameter Store values under a path (decrypted) 

handler

Secrets Manager JSON secret (but only includes safe metadata like host/port/dbname/username in the evidence bundle) 

handler

Runs CloudWatch Logs Insights queries against:

app log group (errors + error rate)

WAF log group (actions + blocks by clientIp/uri) 

handler

Builds an evidence JSON bundle + uses Bedrock to generate a Markdown report

Saves both to S3 under reports/...

Sends an SNS notification with the S3 locations 

handler

Note: in bedrock_generate() it uses an inputText style body that isn’t the Claude message format. The comment even says students must adapt depending on the model. So: handler.py might work “as-is” for some Bedrock models, but not automatically for Claude unless you swap its request format. 

handler

3) gate_secrets_and_role.sh — “Secrets + IAM Role” gate (PASS/FAIL)

This is a pre-flight + permissions gate:

Confirms AWS creds work (sts get-caller-identity)

Confirms the secret exists (describe-secret)

Optional checks:

require rotation

fail if secret resource policy has wildcard Principal "*"

if running on the EC2 instance, can verify the role is assumed and (optionally) the role can read the secret value without printing it 

gate_secrets_and_role

Writes gate_result.json and exits 0/2/1 like a CI gate. 

gate_secrets_and_role

4) gate_network_db.sh — “EC2 ↔ RDS network” gate (PASS/FAIL)

This checks the architecture is not accidentally public and that SG wiring is correct:

RDS exists

RDS is not publicly accessible

Finds DB port (or you override DB_PORT)

Verifies RDS SG allows SG-to-SG ingress from the EC2 SG on the DB port

Fails if DB port is open to the world (0.0.0.0/0 or ::/0)

Optional: verify DB subnets are private (no IGW route) 

gate_network_db

5) run_all_gates.sh — runs both gates + creates a combined badge

Runs:

gate_secrets_and_role.sh → gate_secrets_and_role.json

gate_network_db.sh → gate_network_db.json

Outputs combined gate_result.json + prints a badge:

GREEN = all pass

YELLOW = pass w/ warnings

RED = fail 

run_all_gates

6) how_to_script.txt — explains the “gate mindset”

This is basically your “why this exists” doc:

checklist → repeatable script → evidence JSON → exit codes for CI/CD 

how_to_script

Best order to run them (to safeguard Terraform)
Phase 0 — before you change anything (fast safety)

Format + validate

terraform fmt -recursive

terraform validate

Plan

terraform plan

(These catch “Terraform is broken” problems before you create resources.)

Phase 1 — after terraform apply (architecture safety gates)

Run the gates (recommended: via run_all_gates.sh)
Run this from the folder containing the gate scripts:

REGION=us-east-1 INSTANCE_ID=i-... SECRET_ID=... DB_ID=... ./run_all_gates.sh 

run_all_gates

Why this order inside the gate runner?

It checks Secrets + Role first (if IAM/secret is wrong, there’s no point checking DB connectivity yet).

Then it checks Network + DB correctness.

What you get: hard PASS/FAIL evidence + JSON artifacts you can attach to a “proof pack.”

Phase 2 — after gates pass (higher-level incident report automation)

Trigger the Lambda (handler.py) (once logs/SSM/secret exist)
Run it as an actual Lambda (or invoke it) after the infrastructure exists and is producing logs.

It will generate your incident report + evidence bundle in S3 and send SNS. 

handler

Optional / ad-hoc helper

Use claude.py when you want quick, manual analysis
Example use-cases:

“Summarize these gate JSON results”

“Turn this evidence JSON into a short executive summary”

“Explain what this WAF block pattern means”

It’s not a “gate” by itself—it’s a model-invoker utility. 

claude

Practical “safe run” sequence (simple checklist)

terraform fmt -recursive

terraform validate

terraform plan

terraform apply

./run_all_gates.sh (with env vars set) 

run_all_gates

If GREEN/YELLOW → invoke Lambda report generator (handler.py in Lambda) 

handler

Use claude.py for manual Q&A / summaries 

claude

If you paste your Instance ID, DB identifier, and Secret name (the three inputs the gate runner expects), I can