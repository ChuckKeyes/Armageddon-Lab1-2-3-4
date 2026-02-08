aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=ceklab1-ec201" "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].{PublicIP:PublicIpAddress,DNS:PublicDnsName}" \
  --output table

Environment=SECRET_ID=lab/rds/mysql
Environment=AWS_REGION=us-east-1



curl -s http://PUBLIC_IP/
curl -s http://PUBLIC_IP/init
curl -s "http://PUBLIC_IP/add?note=hello"
curl -s http://PUBLIC_IP/list


If you can SSM into the instance:

sudo systemctl status rdsapp --no-pager
sudo journalctl -u rdsapp -n 200 --no-pager
