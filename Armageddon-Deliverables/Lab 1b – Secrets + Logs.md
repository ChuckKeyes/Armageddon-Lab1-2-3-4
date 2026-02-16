```mermaid
flowchart LR
    EC2 --> SSM
    EC2 --> SecretsManager
    EC2 --> CloudWatchLogs --> Alarm
