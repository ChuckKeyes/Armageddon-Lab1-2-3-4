
Resources were shut down in dependency-safe order: EC2 consumers first, followed by RDS producers, Secrets Manager, IAM roles, security groups, and finally networking components. This prevents orphaned dependencies and ongoing service charges.

AWS and GCP both operate global private backbones; the difference is that GCP exposes it as a single global network abstraction, while AWS enforces regional isolation and requires explicit connectivity constructs to use its backbone.