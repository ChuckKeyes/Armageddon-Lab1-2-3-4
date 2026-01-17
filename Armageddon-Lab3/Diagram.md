┌────────────────────────────┐        ┌────────────────────────────┐
│ Tokyo (ap-northeast-1)             │        │ São Paulo (sa-east-1)                 │
│                                                   │        │                                                    │
│  ┌───────────────┐                  │        │        ┌───────────────┐             │
│  │ Shinjuku TGW  │◀────────  ┼────────▶│ Liberdade TGW  │             │
│  └───────────────┘  TGW        │ Peering │  └───────────────┘             │
│        ▲                                        │Attachment│        ▲                              │
│        │                                         │        │                    │                              │
│  ┌───────────────┐                  │        │  ┌───────────────┐                  │
│  │ Tokyo VPC(s)  │                      │        │  │ SP VPC(s)     │                        │
│  └───────────────┘                  │        │  └───────────────┘                  │
└────────────────────────────┘        └────────────────────────────┘


![[Pasted image 20260108205140.png]]

![[Pasted image 20260108205211.png]]

![[Pasted image 20260108205243.png]]


### Region 1 — **Tokyo (ap-northeast-1)**

- **TGW: `shinjuku_tgw`**
    
- VPCs:
    
    - Medical Data VPC (PHI authority)
        
- TGW VPC Attachments
    
- **TGW Peering Attachment (initiator)** → São Paulo
    

### Region 2 — **São Paulo (sa-east-1)**

- **TGW: `liberdade_tgw`**
    
- VPCs:
    
    - Compute / App / Doctors access
        
- TGW VPC Attachments
    
- **TGW Peering Attachment Accepter**
    

### Between Regions

- **TGW ↔ TGW Peering**
    
- Encrypted, AWS-managed backbone
    
- No public routing
    
- Independent Terraform states ✔