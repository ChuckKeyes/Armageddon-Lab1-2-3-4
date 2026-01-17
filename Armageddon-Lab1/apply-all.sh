#!/usr/bin/env bash
set -euo pipefail

STAGES=(
  "1-network"
  "2-security"
  "3-iam"
  "4-rds"
  "5-compute"
  "6-config"
  "7-notifications"
  "8-observability"
)

echo "=============================================="
echo "🚀 KCS Terraform Stage Runner"
echo "Project: kcs-keyescloudsolutions"
echo "Region:  us-east-1"
echo "=============================================="

for STAGE in "${STAGES[@]}"; do
  echo
  echo "----------------------------------------------"
  echo "▶ APPLYING STAGE: $STAGE"
  echo "----------------------------------------------"

  cd "stages/$STAGE"

  terraform init -upgrade
  terraform validate
  terraform plan
  terraform apply -auto-approve

  cd - >/dev/null

  echo "✅ STAGE COMPLETED: $STAGE"
done

echo
echo "=============================================="
echo "🎉 ALL STAGES APPLIED SUCCESSFULLY"
echo "=============================================="
