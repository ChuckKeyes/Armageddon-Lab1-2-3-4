```mermaid
flowchart LR
    Alarm --> SNS --> Lambda
    Lambda --> Bedrock
    Lambda --> S3
