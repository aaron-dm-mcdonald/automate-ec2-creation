#!/bin/bash

# Basic EC2 automation script 

# Please note: 
# Uses default region
# Requires no input 
# Edit line 11-13

# Default values
SG_NAME="default-sg-test"
KEY_NAME="default-key-test"
INSTANCE_NAME="my-ec2-instance"

# Get the first Subnet ID
SUBNET_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) > /dev/null

# Configure Security Group
aws ec2 create-security-group --group-name $SG_NAME --description "My security group" > /dev/null
SG_ID=$(aws ec2 describe-security-groups --group-names $SG_NAME --query 'SecurityGroups[0].GroupId' --output text) > /dev/null
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 > /dev/null

# Create Key Pair
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem > /dev/null
chmod 400 $KEY_NAME.pem > /dev/null

# Get Amazon Linux 2023 AMI ID
AMI_ID=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[0].ImageId" --output text) > /dev/null

# EC2 Instance Creation/Connection ----------

# Create EC2 Instance
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --key-name $KEY_NAME --security-group-ids $SG_ID --subnet-id $SUBNET_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" > /dev/null

# Get Instance ID
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" --query "Reservations[*].Instances[*].InstanceId" --output text) > /dev/null

# Get Public DNS of the EC2 Instance
PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].PublicDnsName" --output text) > /dev/null

# Instructions to SSH into the EC2 Instance
echo "To SSH into your EC2 instance, use the following command:"
echo "ssh -i \"$KEY_NAME.pem\" ec2-user@$PUBLIC_DNS"
