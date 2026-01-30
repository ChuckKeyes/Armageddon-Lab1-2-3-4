## Set your basics (one-time)

# pick your region
export AWS_REGION="us-east-1"

# your lab resource names (adjust if yours differ)
export SSM_ENDPOINT="/lab/db/endpoint"
export SSM_PORT="/lab/db/port"
export SSM_NAME="/lab/db/name"
export SECRET_ID="lab/rds/mysql"

export LOG_GROUP="/aws/ec2/lab-rds-app"
export ALARM_PREFIX="lab-db-connection"

############################################################################################

aws sts get-caller-identity --region "$AWS_REGION"

############################################################################################

## Prove Parameter Store values exist (and decrypt works)

aws ssm get-parameters \
  --region "$AWS_REGION" \
  --names "$SSM_ENDPOINT" "$SSM_PORT" "$SSM_NAME" \
  --with-decryption \
  --query "Parameters[].{Name:Name,Value:Value,Type:Type}" \
  --output table

##############################################################################################

## Prove Secrets Manager secret exists

aws secretsmanager get-secret-value \
  --region "$AWS_REGION" \
  --secret-id "$SECRET_ID" \
  --query "from_json(SecretString) | keys(@)" \
  --output table

##############################################################################################

## Full JSON

aws secretsmanager get-secret-value \
  --region "$AWS_REGION" \
  --secret-id "$SECRET_ID" \
  --query "SecretString" \
  --output text

## Prove EC2 can read both systems (run on the EC2)
## SSH to the EC2, then:

aws ssm get-parameter \
  --region "$AWS_REGION" \
  --name "$SSM_ENDPOINT" \
  --query "Parameter.Value" \
  --output text

aws secretsmanager get-secret-value \
  --region "$AWS_REGION" \
  --secret-id "$SECRET_ID" \
  --query "ARN" \
  --output text

################################################################################################

## Prove CloudWatch Log Group exists

aws logs describe-log-groups \
  --region "$AWS_REGION" \
  --log-group-name-prefix "$LOG_GROUP" \
  --query "logGroups[].logGroupName" \
  --output table
## Expected: shows /aws/ec2/lab-rds-app (or your actual name).

####################################################################################################

## Prove DB failure logs appear (last 30 minutes)

START_MS=$(( ( $(date +%s) - 1800 ) * 1000 ))

aws logs filter-log-events \
  --region "$AWS_REGION" \
  --log-group-name "$LOG_GROUP" \
  --start-time "$START_MS" \
  --filter-pattern "ERROR" \
  --query "events[].{ts:timestamp,msg:message}" \
  --output table
## Expected: when you simulate failure, you see explicit DB connection errors.

## Prove the CloudWatch Alarm exists + check its state
# List alarms

aws cloudwatch describe-alarms \
  --region "$AWS_REGION" \
  --alarm-name-prefix "$ALARM_PREFIX" \
  --query "MetricAlarms[].{Name:AlarmName,State:StateValue,Reason:StateReason}" \
  --output table

# If you want a quick “state-only” check:

aws cloudwatch describe-alarms \
  --region "$AWS_REGION" \
  --alarm-name-prefix "$ALARM_PREFIX" \
  --query "MetricAlarms[].{Name:AlarmName,State:StateValue}" \
  --output table
# Expected: during failure it transitions to ALARM, after recovery it returns to OK.

##################################################################################################

## Prove recovery (app works again)

curl -i "http://<EC2_PUBLIC_IP>/list"
# Expected: HTTP/1.1 200 (or 301 then 200 depending on your app).

################################################################################################

## Extra “Proof Pack” trick (captures evidence cleanly)
# If you want a single text file you can submit:

{
  echo "=== WHOAMI ==="
  aws sts get-caller-identity --region "$AWS_REGION"

  echo -e "\n=== SSM PARAMETERS ==="
  aws ssm get-parameters --region "$AWS_REGION" --names "$SSM_ENDPOINT" "$SSM_PORT" "$SSM_NAME" --with-decryption \
    --query "Parameters[].{Name:Name,Value:Value,Type:Type}" --output table

  echo -e "\n=== SECRET KEYS (SAFE) ==="
  aws secretsmanager get-secret-value --region "$AWS_REGION" --secret-id "$SECRET_ID" \
    --query "from_json(SecretString) | keys(@)" --output table

  echo -e "\n=== LOG GROUP ==="
  aws logs describe-log-groups --region "$AWS_REGION" --log-group-name-prefix "$LOG_GROUP" \
    --query "logGroups[].logGroupName" --output table

  echo -e "\n=== ALARMS ==="
  aws cloudwatch describe-alarms --region "$AWS_REGION" --alarm-name-prefix "$ALARM_PREFIX" \
    --query "MetricAlarms[].{Name:AlarmName,State:StateValue}" --output table
} | tee lab1b_proof.txt

####################################################################################################

## If your actual names differ (very possible), run these two “discovery” commands and I’ll adapt everything to your real resource names:

aws ssm describe-parameters --region "$AWS_REGION" --query "Parameters[?starts_with(Name, '/lab/')].Name" --output table
aws secretsmanager list-secrets --region "$AWS_REGION" --query "SecretList[?contains(Name,'lab')].Name" --output table
