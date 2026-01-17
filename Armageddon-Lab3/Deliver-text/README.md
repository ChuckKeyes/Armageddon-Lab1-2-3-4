
audit-pack/
├── 00_architecture-summary.md
├── 01_data-residency-proof.txt
├── 02_edge-proof-cloudfront.txt
├── 03_waf-proof.txt
├── 04_cloudtrail-change-proof.txt
├── 05_network-corridor-proof.txt
└── evidence.json


### What to put in each file (using what you already have)

**00_architecture-summary.md**  
Use a tight summary pulled from your Lab 3A/3B text:

- Tokyo = data authority (RDS only there)
    
- São Paulo = compute only
    
- TGW peering = explicit corridor
    
- CloudFront + WAF = single global entrypoint  
    Source your wording from these.
    

**01_data-residency-proof.txt**  
Paste either:

- CLI outputs listed in deliverables, or
    
- the JSON output from `malgus_residency_proof.py` (even better because it includes PASS/FAIL).
    

**02_edge-proof-cloudfront.txt**  
Include:

- `curl -I https://...` header proof (as the deliverables say), and/or
    
- the output of your CloudFront log script showing Hit/Miss/RefreshHit counts.
    

**03_waf-proof.txt** and **04_cloudtrail-change-proof.txt**  
Your deliverables mention scripts like `malgus_cloudtrail_last_changes.py` and `malgus_waf_summary.py`, but those scripts are **not** in the files you uploaded here. So for now:

- put CLI/console evidence (screenshots or copied outputs) OR
    
- add those scripts later if you have them.
    

**05_network-corridor-proof.txt**  
Use:

- your TGW snapshot script output (TGWs + attachments), and
    
- route table CLI proof if you want extra strength.
    

**evidence.json**  
This is your “single machine-readable artifact.” Best practice: paste the JSON outputs from:

- residency script
    
- TGW corridor script
    
- CloudFront cache report summary (or just paste the count block)
    

## Run commands (copy/paste)

### 1) Data residency (script)

`python3 malgus_residency_proof.py > audit-pack/01_data-residency-proof.txt`

malgus_residency_proof

### 2) TGW corridor (script)

`python3 malgus_tgw_corridor_proof.py > audit-pack/05_network-corridor-proof.txt`

malgus_tgw_corridor_proof

### 3) CloudFront cache/access proof (script)

Your script expects logs in **S3 bucket `Class_Lab3`** and optionally a prefix. Examples:

`python3 malgus_cloudfront_log_explainer.py --latest 5 > audit-pack/02_edge-proof-cloudfront.txt`

If your logs are under a folder:

`python3 malgus_cloudfront_log_explainer.py --prefix cloudfront-logs/ --latest 10 > audit-pack/02_edge-proof-cloudfront.txt`

### 4) “Evidence bundle” JSON (simple way)

If you want a quick evidence.json without writing a new script, you can do this manually:

`cat audit-pack/01_data-residency-proof.txt > audit-pack/evidence.json`

Better: later you can make a tiny “collector” script that runs all three and merges into one JSON object, but you already have enough for grading right now.

## Auditor narrative (8–12 lines you can paste as Deliverable B)

Use this as your paragraph (matches the 3B requirement).

> This design enforces data residency by keeping all patient medical records stored only in Tokyo (ap-northeast-1), while allowing global access through controlled, auditable paths. São Paulo (sa-east-1) runs stateless compute only and does not host databases or PHI at rest. Transit Gateway peering creates an explicit cross-region corridor that can be verified via attachments and route tables, eliminating undocumented routing paths. CloudFront provides a single global entrypoint and WAF applies edge security controls, so direct origin access is minimized and measurable. CloudFront access behavior and caching outcomes can be proven via standard logs (Hit/Miss/RefreshHit). CloudTrail and WAF logs provide accountable evidence of who changed configurations and how requests were allowed or blocked. The result is an architecture that prioritizes provable compliance: access is global, storage remains in-region, and key actions are retained as audit artifacts.