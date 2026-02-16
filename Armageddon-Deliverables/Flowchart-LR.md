```mermaid
flowchart LR
    CW[CloudWatch Alarm] --> SNS[SNS Topic]
    SNS -->|Invoke| L[Lambda IR Reporter]
    L --> CWL[CloudWatch Logs]
    L --> SSM[SSM Parameter Store]
    L --> SM[Secrets Manager]
    L --> BR[Amazon Bedrock]
    L --> S3[S3 Incident Reports Bucket]

    subgraph Evidence Collection
      CWL
      SSM
      SM
    end

    subgraph AI Summary
      BR
    end
