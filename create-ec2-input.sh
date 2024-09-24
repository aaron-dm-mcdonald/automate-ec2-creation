#!/bin/bash

# Automate creation of EC2 instance 

# Prompt for user input
read -p "Enter the AWS region: " REGION
read -p "Enter the Security Group name: " SG_NAME
read -p "Enter the Key Pair name: " KEY_NAME

# Get the first VPC ID
VPC_ID=$(aws ec2 describe-vpcs --region $REGION --query 'Vpcs[0].VpcId' --output text)
echo "Using VPC ID: $VPC_ID"

# Get the first Subnet ID in the VPC
SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --region $REGION --query 'Subnets[0].SubnetId' --output text)
echo "Using Subnet ID: $SUBNET_ID"

# Variables
INSTANCE_TYPE="t2.micro"
AMI_NAME="amzn2-ami-hvm-*-x86_64-gp2"

# Create Security Group
SG_ID=$(aws ec2 create-security-group --group-name $SG_NAME --description "My security group" --vpc-id $VPC_ID --region $REGION --query 'GroupId' --output text)
echo "Created Security Group with ID: $SG_ID"

# Add SSH Inbound Rule to Security Group
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
echo "Added SSH inbound rule to Security Group"

# Create Key Pair
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text --region $REGION > $KEY_NAME.pem
chmod 400 $KEY_NAME.pem
echo "Created Key Pair and saved to $KEY_NAME.pem"

# Get Amazon Linux 2023 AMI ID
AMI_ID=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=$AMI_NAME" --query "Images[0].ImageId" --output text --region $REGION)
echo "Amazon Linux 2023 AMI ID: $AMI_ID"

# Create EC2 Instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_ID --subnet-id $SUBNET_ID --region $REGION --query 'Instances[0].InstanceId' --output text)
echo "Created EC2 Instance with ID: $INSTANCE_ID"

# Get Public DNS of the EC2 Instance
PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].PublicDnsName" --output text --region $REGION)
echo "EC2 Instance Public DNS: $PUBLIC_DNS"

# Instructions to SSH into the EC2 Instance
echo "To SSH into your EC2 instance, use the following command:"
echo "ssh -i \"$KEY_NAME.pem\" ec2-user@$PUBLIC_DNS"
