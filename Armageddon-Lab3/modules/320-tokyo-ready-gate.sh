chmod +x tokyo_ready_gate.sh

export AWS_PROFILE=default
export TOKYO_REGION=ap-northeast-1
export TOKYO_VPC_ID="vpc-xxxxxxxx"
export TOKYO_TGW_ID="tgw-xxxxxxxx"
export TOKYO_RDS_ENDPOINT="yourdb.abc123.ap-northeast-1.rds.amazonaws.com"

# Optional but recommended
export TOKYO_VPC_CIDR="10.10.0.0/16"
export SP_VPC_CIDR="10.20.0.0/16"

./tokyo_ready_gate.sh
