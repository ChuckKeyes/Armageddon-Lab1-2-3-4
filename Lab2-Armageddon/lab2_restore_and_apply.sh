#!/bin/bash
set -e

SECRET_ID="armageddon/lab2/tokyo/rds"
REGION="ap-northeast-1"
TF_RESOURCE="aws_secretsmanager_secret.db[0]"

echo "==============================================="
echo "Lab2: apply -> restore secret -> import -> apply"
echo "==============================================="

echo ""
echo "Step 0: Terraform apply (first pass)..."
terraform apply -auto-approve

echo ""
echo "Step 1: Restoring Secrets Manager secret..."
aws secretsmanager restore-secret \
  --secret-id "$SECRET_ID" \
  --region "$REGION"

echo ""
echo "Step 2: Verifying secret is not pending deletion (DeletedDate should be null)..."
aws secretsmanager describe-secret \
  --secret-id "$SECRET_ID" \
  --region "$REGION" \
  --query "DeletedDate"

echo ""
echo "Step 3: Importing secret into Terraform state (ok if already imported)..."
terraform import "$TF_RESOURCE" "$SECRET_ID" || true

echo ""
echo "Step 4: Terraform apply (second pass)..."
terraform apply -auto-approve

echo ""
echo "==============================================="
echo "DONE"
echo "==============================================="