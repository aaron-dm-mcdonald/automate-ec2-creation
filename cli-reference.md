# Configure EC2 instance via CLI 

## Prerequisites 
1) Ensure you have configured your AWS CLI. Verify by executing:
aws configure
and press enter 4 times. Are all fields populated? 

2) CLI to use: 
Windows: Use Git Bash
MacOS: Bash/ZSH (whatever is default)
Linux: You all know...

3) You *might* have issues with SSH if you are using a network other than your own. 

4) You will want to watch Nana's videos. Most of these commands should match her's. I believe I use a different query for the AMI. 

## Regional resources and the CLI
The CLI utility will default to your default region if no additional parameters are passed in the command. If your default region is us-east-1 then all regional commands will default to that region. To modify the region without changing the default region you typically append a "--region <desired region>" flag to the command in question. 

## Command Reference


### Get various EC2 information
#### List EC2 instances
aws ec2 describe-instances

#### List VPCs
aws ec2 describe-vpcs

#### List Subnets
aws ec2 describe-subnets

#### list SG 
aws ec2 describe-security-groups



### configure SG
#### create SG
aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" --vpc-id <your-vpc-id>

#### add SSH ingress rule to SG
aws ec2 authorize-security-group-ingress --group-id <your-sg-id> --protocol tcp --port 22 --cidr 0.0.0.0/0

#### list SG 
aws ec2 describe-security-groups



### key pair config 
#### create key pair 
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem

#### change permissons to read only  
chmod 400 MyKeyPair.pem


### List desired AMI ID
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[*].[ImageId,Name]"


### EC2 instance creation and connect
#### create and connect to EC2 instance 
aws ec2 run-instances --image-id <ami-id> --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids <your-sg-id> --subnet-id <your-subnet-id>

#### Grab public DNS
aws ec2 describe-instances --instance-ids <your-instance-id> --query "Reservations[*].Instances[*].PublicDnsName" --output text

#### SSH into EC2 instance
ssh -i "MyKeyPair.pem" ec2-user@<your-ec2-public-dns>
