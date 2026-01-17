#!/usr/bin/env bash
set -euo pipefail

STAGES=(
  "8-observability"
  "7-notifications"
  "6-config"
  "5-compute"
  "4-rds"
  "3-iam"
  "2-security"
  "1-network"
)

echo "=============================================="
echo "🔥 KCS Terraform DESTROY Runner"
echo "=============================================="

for STAGE in "${STAGES[@]}"; do
  echo
  echo "----------------------------------------------"
  echo "▶ DESTROYING STAGE: $STAGE"
  echo "----------------------------------------------"

  cd "stages/$STAGE"
  terraform destroy -auto-approve
  cd - >/dev/null

  echo "🧹 STAGE DESTROYED: $STAGE"
done

echo
echo "=============================================="
echo "💀 ALL STAGES DESTROYED"
echo "=============================================="
