```mermaid
flowchart TB
    ROOT[Root Terraform]
    MOD[bonus_g_bedrock_autoreport module]

    ROOT -->|passes vars| MOD
    MOD -->|creates| S3B[S3 Bucket]
    MOD -->|creates| IAM[IAM Role + Policy]
    MOD -->|uploads| ZIP[Lambda ZIP]
    MOD -->|creates| L[Lambda]
    MOD -->|subscribes| SNS[SNS Topic]
