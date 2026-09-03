#!/bin/bash

SG_ID="sg-06b04b086fc258608"
AMI_ID="ami-0b6d9d3d33ba97d99"


for instance in $@
do
    aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$instance'}]' 
    --query 'Reservation[0].Instances[0].PrivateIpAddress' --output text
done