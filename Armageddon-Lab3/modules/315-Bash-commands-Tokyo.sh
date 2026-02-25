#!/usr/bin/env bash
set -euo pipefail

#############################################
# Tokyo Readiness Gate for São Paulo (Lab3A)
# Checks:
# - Tokyo VPC exists + DNS enabled
# - Tokyo TGW exists
# - Tokyo VPC attachment to TGW is AVAILABLE
# - Tokyo TGW route tables exist + have at least local/blackhole sanity
# - Tokyo VPC route tables send (planned) SP CIDR back to TGW (optional, if provided)
# - Tokyo RDS endpoint resolves to private IPs (DNS check)
# Optional:
# - TGW peering attachment to São Paulo exists (if SP_TGW_ID provided)
#############################################

### REQUIRED (set these)
: "${TOKYO_REGION:=ap-northeast-1}"
: "${AWS_PROFILE:=default}"

: "${TOKYO_VPC_ID:?Set TOKYO_VPC_ID (e.g., vpc-xxxxxxxx)}"
: "${TOKYO_TGW_ID:?Set TOKYO_TGW_ID (e.g., tgw-xxxxxxxx)}"

# Optional but strongly recommended for DB readiness
: "${TOKYO_RDS_ENDPOINT:=}"      # e.g., mydb.abc123xyz.ap-northeast-1.rds.amazonaws.com
: "${TOKYO_VPC_CIDR:=}"          # e.g., 10.10.0.0/16 (if blank, script will look it up)

### OPTIONAL (set when known)
: "${SP_VPC_CIDR:=}"             # e.g., 10.20.0.0/16 (future São Paulo VPC CIDR)
: "${SP_TGW_ID:=}"               # e.g., tgw-yyyyyyyy (future São Paulo TGW ID, if already created)
: "${EXPECTED_TOKYO_ATTACH_STATE:=available}"

AWS="aws --profile ${AWS_PROFILE} --region ${TOKYO_REGION}"

pass() { echo "✅ PASS: $*"; }
fail() { echo "❌ FAIL: $*" >&2; exit 1; }
warn() { echo "⚠️  WARN: $*" >&2; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"; }

need_cmd aws
need_cmd bash
need_cmd grep
need_cmd awk
need_cmd sed

echo "============================================================"
echo "Tokyo Readiness Gate (Region: ${TOKYO_REGION}, Profile: ${AWS_PROFILE})"
echo "VPC: ${TOKYO_VPC_ID}"
echo "TGW: ${TOKYO_TGW_ID}"
echo "============================================================"

echo
echo "1) Validate Tokyo VPC exists + DNS settings"
vpc_json="$($AWS ec2 describe-vpcs --vpc-ids "${TOKYO_VPC_ID}" --output json 2>/dev/null)" \
  || fail "Tokyo VPC not found: ${TOKYO_VPC_ID}"
pass "Tokyo VPC exists"

dns_support="$($AWS ec2 describe-vpc-attribute --vpc-id "${TOKYO_VPC_ID}" --attribute enableDnsSupport \
  --query 'EnableDnsSupport.Value' --output text)"
dns_hostnames="$($AWS ec2 describe-vpc-attribute --vpc-id "${TOKYO_VPC_ID}" --attribute enableDnsHostnames \
  --query 'EnableDnsHostnames.Value' --output text)"

[[ "${dns_support}" == "True" ]]   && pass "VPC enableDnsSupport=True"   || fail "VPC enableDnsSupport is not True"
[[ "${dns_hostnames}" == "True" ]] && pass "VPC enableDnsHostnames=True" || warn "VPC enableDnsHostnames is not True (RDS usually still works, but best to enable)"

if [[ -z "${TOKYO_VPC_CIDR}" ]]; then
  TOKYO_VPC_CIDR="$($AWS ec2 describe-vpcs --vpc-ids "${TOKYO_VPC_ID}" --query 'Vpcs[0].CidrBlock' --output text)"
  pass "Discovered TOKYO_VPC_CIDR=${TOKYO_VPC_CIDR}"
else
  pass "Using provided TOKYO_VPC_CIDR=${TOKYO_VPC_CIDR}"
fi

echo
echo "2) Validate Tokyo TGW exists"
$AWS ec2 describe-transit-gateways --transit-gateway-ids "${TOKYO_TGW_ID}" --query 'TransitGateways[0].State' --output text \
  >/dev/null 2>&1 || fail "Tokyo TGW not found: ${TOKYO_TGW_ID}"
tgw_state="$($AWS ec2 describe-transit-gateways --transit-gateway-ids "${TOKYO_TGW_ID}" --query 'TransitGateways[0].State' --output text)"
[[ "${tgw_state}" == "available" ]] && pass "Tokyo TGW state=available" || warn "Tokyo TGW state=${tgw_state} (expected: available)"

echo
echo "3) Validate Tokyo VPC attachment to TGW is ${EXPECTED_TOKYO_ATTACH_STATE}"
attach_id="$($AWS ec2 describe-transit-gateway-vpc-attachments \
  --filters "Name=transit-gateway-id,Values=${TOKYO_TGW_ID}" "Name=vpc-id,Values=${TOKYO_VPC_ID}" \
  --query 'TransitGatewayVpcAttachments[0].TransitGatewayAttachmentId' --output text)"

[[ "${attach_id}" != "None" && -n "${attach_id}" ]] || fail "No TGW VPC attachment found between TGW ${TOKYO_TGW_ID} and VPC ${TOKYO_VPC_ID}"

attach_state="$($AWS ec2 describe-transit-gateway-vpc-attachments \
  --transit-gateway-attachment-ids "${attach_id}" \
  --query 'TransitGatewayVpcAttachments[0].State' --output text)"

[[ "${attach_state}" == "${EXPECTED_TOKYO_ATTACH_STATE}" ]] \
  && pass "Tokyo TGW-VPC attachment ${attach_id} state=${attach_state}" \
  || fail "Tokyo TGW-VPC attachment ${attach_id} state=${attach_state} (expected: ${EXPECTED_TOKYO_ATTACH_STATE})"

echo
echo "4) Validate Tokyo TGW route tables exist"
tgw_rtb_ids="$($AWS ec2 describe-transit-gateway-route-tables \
  --filters "Name=transit-gateway-id,Values=${TOKYO_TGW_ID}" \
  --query 'TransitGatewayRouteTables[].TransitGatewayRouteTableId' --output text)"

[[ -n "${tgw_rtb_ids}" ]] || fail "No TGW route tables found for TGW ${TOKYO_TGW_ID}"
pass "Found TGW route table(s): ${tgw_rtb_ids}"

echo
echo "5) Validate Tokyo VPC route tables exist (and optional SP return route)"
rtb_ids="$($AWS ec2 describe-route-tables --filters "Name=vpc-id,Values=${TOKYO_VPC_ID}" \
  --query 'RouteTables[].RouteTableId' --output text)"
[[ -n "${rtb_ids}" ]] || fail "No VPC route tables found for VPC ${TOKYO_VPC_ID}"
pass "Found VPC route table(s): ${rtb_ids}"

if [[ -n "${SP_VPC_CIDR}" ]]; then
  echo "   Checking that Tokyo VPC RTs have a route to SP_VPC_CIDR=${SP_VPC_CIDR} via TGW ${TOKYO_TGW_ID}"
  found_route="false"
  for rtb in ${rtb_ids}; do
    target="$($AWS ec2 describe-route-tables --route-table-ids "${rtb}" \
      --query "RouteTables[0].Routes[?DestinationCidrBlock=='${SP_VPC_CIDR}'].[TransitGatewayId,GatewayId,InstanceId,NatGatewayId]" \
      --output text || true)"
    if echo "${target}" | grep -q "${TOKYO_TGW_ID}"; then
      pass "RouteTable ${rtb} has ${SP_VPC_CIDR} -> ${TOKYO_TGW_ID}"
      found_route="true"
    fi
  done
  [[ "${found_route}" == "true" ]] || fail "No Tokyo VPC route table sends ${SP_VPC_CIDR} to TGW ${TOKYO_TGW_ID} (needed for return traffic once SP exists)"
else
  warn "SP_VPC_CIDR not set — skipping Tokyo return-route check (set SP_VPC_CIDR later to enforce this gate)."
fi

echo
echo "6) Optional: Validate TGW peering attachment to São Paulo TGW (if SP_TGW_ID is set)"
if [[ -n "${SP_TGW_ID}" ]]; then
  peer_attach="$($AWS ec2 describe-transit-gateway-peering-attachments \
    --filters "Name=requester-transit-gateway-id,Values=${TOKYO_TGW_ID}" \
              "Name=accepter-transit-gateway-id,Values=${SP_TGW_ID}" \
    --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' --output text)"

  [[ "${peer_attach}" != "None" && -n "${peer_attach}" ]] || fail "No TGW peering attachment found (Tokyo TGW ${TOKYO_TGW_ID} -> SP TGW ${SP_TGW_ID})"

  peer_state="$($AWS ec2 describe-transit-gateway-peering-attachments \
    --transit-gateway-attachment-ids "${peer_attach}" \
    --query 'TransitGatewayPeeringAttachments[0].State' --output text)"

  # acceptable states before SP accepts: pendingAcceptance / available
  if [[ "${peer_state}" == "available" ]]; then
    pass "TGW peering attachment ${peer_attach} state=available"
  else
    warn "TGW peering attachment ${peer_attach} state=${peer_state} (expected available after SP accepts)"
  fi
else
  warn "SP_TGW_ID not set — skipping peering check (this is fine if SP isn’t built yet)."
fi

echo
echo "7) Optional: Check Tokyo RDS endpoint DNS resolves (private IP expectation)"
if [[ -n "${TOKYO_RDS_ENDPOINT}" ]]; then
  if command -v getent >/dev/null 2>&1; then
    ips="$(getent ahosts "${TOKYO_RDS_ENDPOINT}" | awk '{print $1}' | sort -u || true)"
    [[ -n "${ips}" ]] && pass "RDS endpoint resolves: ${TOKYO_RDS_ENDPOINT} -> ${ips}" || fail "Could not resolve RDS endpoint: ${TOKYO_RDS_ENDPOINT}"
  elif command -v nslookup >/dev/null 2>&1; then
    ips="$(nslookup "${TOKYO_RDS_ENDPOINT}" 2>/dev/null | awk '/^Address: /{print $2}' | sort -u || true)"
    [[ -n "${ips}" ]] && pass "RDS endpoint resolves: ${TOKYO_RDS_ENDPOINT} -> ${ips}" || fail "Could not resolve RDS endpoint: ${TOKYO_RDS_ENDPOINT}"
  else
    warn "No getent or nslookup available — skipping DNS resolution check."
  fi
else
  warn "TOKYO_RDS_ENDPOINT not set — skipping RDS DNS check."
fi

echo
echo "============================================================"
echo "✅ Tokyo readiness gate complete."
echo "If all PASS (and the WARNs are acceptable), Tokyo is ready to proceed with São Paulo."
echo "============================================================"
