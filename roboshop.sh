#!/bin/bash
SG_ID="sg-0cbd13a547e558c9a"
AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z09377683CDJHFYUS3OAB"
DOMAIN_NAME="sanjeethadevops.online"

for instance in $@
do 
  INSTANCE_ID=$( aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type "t3.micro" \
  --security-group-ids $SG_ID \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
  --query 'Instances[0].InstanceId' \
  --output text )

if [ $instance == "frontend" ]; then

IP=$( 
    aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[].Instances[].PublicIpAddress' \
  --output text
)
RECORD_NAME="$DOMAIN_NAME"  #mongodb.sanjeethadevops.online
else
IP=$( 
    aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[].Instances[].PrivateIpAddress' \
  --output text
)
RECORD_NAME="$instance.$DOMAIN_NAME" 
fi

echo "IP Address is :$IP"

echo "DEBUG:"
echo "instance='$instance'"
echo "DOMAIN_NAME='$DOMAIN_NAME'"
echo "RECORD_NAME='$RECORD_NAME'"
aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '{
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$RECORD_NAME'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            { "Value": "'$IP'" }
          ]
        }
      }
    ]
  }'

  echo "record updated for $instance"

done
