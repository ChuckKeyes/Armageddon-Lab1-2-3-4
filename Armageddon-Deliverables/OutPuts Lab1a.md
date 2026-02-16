

     --region us-east-1 \
      --query "SecurityGroups[].{GroupId:GroupId,Name:GroupName,VpcId:VpcId}" \
      --output table
--------------------------------------------------------------
|                   DescribeSecurityGroups                   |
+-----------------------+----------+-------------------------+
|        GroupId        |  Name    |          VpcId          |
+-----------------------+----------+-------------------------+
|  sg-0aed5557f032554c3 |  default |  vpc-0e19e66167ef138e5  |
+-----------------------+----------+-------------------------+

