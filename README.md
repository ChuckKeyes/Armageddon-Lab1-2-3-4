# Armageddon Labs 1–4


aws ec2 describe-transit-gateway-route-tables \
    --filters Name=transit-gateway-id,Values=<transit gateway> \
    --region ap-northeast-1

    
aws ec2 describe-transit-gateway-route-table-propagations \
    --filters Name=transit-gateway-route-table-id,Values=<tg-rt-table> \
    --region ap-northeast-1