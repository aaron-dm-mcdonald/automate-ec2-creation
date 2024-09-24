### configure EC2 instance via CLI 


## Get needed info for EC2 config 
# list EC2 instances
aws ec2 describe-instances

# List VPCs
aws ec2 describe-vpcs

# List Subnets
aws ec2 describe-subnets



## configure SG
# create SG
aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" --vpc-id <your-vpc-id>

# add SSH ingress rule to SG
aws ec2 authorize-security-group-ingress --group-id <your-sg-id> --protocol tcp --port 22 --cidr 0.0.0.0/0

# list SG 
aws ec2 describe-security-groups



## key pair config 
# create key pair 
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem

# change permissons to read only  
chmod 400 MyKeyPair.pem
N

# List desired AMI ID
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[*].[ImageId,Name]"



# create and connect to EC2 instance 
aws ec2 run-instances --image-id <ami-id> --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids <your-sg-id> --subnet-id <your-subnet-id>

# Grab public DNS
aws ec2 describe-instances --instance-ids <your-instance-id> --query "Reservations[*].Instances[*].PublicDnsName" --output text

# SSH into EC2 instance
ssh -i "MyKeyPair.pem" ec2-user@<your-ec2-public-dns>
