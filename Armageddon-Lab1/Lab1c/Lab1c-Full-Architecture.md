```mermaid
flowchart TB
    %% =========================
    %% USERS
    %% =========================
    User[Internet User / Tester]

    %% =========================
    %% BONUS B – PUBLIC INGRESS
    %% =========================
    DNS[Route53<br/>app.domain.com]
    ALB[ALB<br/>HTTPS :443]

    %% =========================
    %% BONUS B – PRIVATE APP
    %% =========================
    EC2[EC2 App Server<br/>Private Subnet]
    RDS[(RDS MySQL<br/>Private Subnet)]

    %% =========================
    %% BONUS A – PRIVATE ACCESS
    %% =========================
    VPCE[Interface VPC Endpoints<br/>SSM / Logs / Secrets]

    %% =========================
    %% LAB 1B / 1C – SECRETS & LOGGING
    %% =========================
    SSM[SSM Parameter Store<br/>/lab/db/*]
    SM[Secrets Manager<br/>db credentials]
    CWL[CloudWatch Logs]
    ALARM[CloudWatch Alarm<br/>DB Errors]

    %% =========================
    %% BONUS G – INCIDENT AUTOMATION
    %% =========================
    SNS[SNS Topic]
    LAMBDA[Lambda IR Reporter]
    BEDROCK[Amazon Bedrock]
    S3[(S3 Incident Reports Bucket)]

    %% =========================
    %% TRAFFIC FLOW
    %% =========================
    User --> DNS --> ALB --> EC2 --> RDS

    %% =========================
    %% PRIVATE AWS ACCESS
    %% =========================
    EC2 --> VPCE
    VPCE --> SSM
    VPCE --> SM
    VPCE --> CWL

    %% =========================
    %% OBSERVABILITY
    %% =========================
    EC2 --> CWL
    CWL --> ALARM

    %% =========================
    %% INCIDENT RESPONSE PIPELINE
    %% =========================
    ALARM --> SNS --> LAMBDA
    LAMBDA --> CWL
    LAMBDA --> SSM
    LAMBDA --> SM
    LAMBDA --> BEDROCK
    LAMBDA --> S3
