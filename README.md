# automate-ec2-creation

## Manual EC2 Creation Steps

1) Open CLI 
2) Verify the CLI is configured (`aws configure`), you have a region chosen, etc
3) 
    - Download and open this: [EC2 CLI Notes](https://github.com/aaron-dm-mcdonald/automate-ec2-creation/blob/main/ec2-notes.txt)
    - Take a peek at this: [CLI Reference](https://github.com/aaron-dm-mcdonald/automate-ec2-creation/blob/main/cli-reference.md)
    - Figure out what data you need to run the `aws ec2 run-instances` command
    - As you figure out info, fill out the text file. 

4) Get your subnet ID
5) Security Group
    - Create SG
    - Get your SG ID 
    - Add inbound rule
6) Get your AMI ID
7) Key Pair
    - Create key pair
    - Make key pair file read only
8) Use the text file from 3) and fill out the `aws ec2 run-instances` command and execute it when ready
9) List EC2 info to verify EC2 launched and get info needed. 
10) Use public DNS and launch SSH Client 
11) Connect to your EC2 instance...

## Basic script (no input or variables) 
1) NOT IN REPO YET! 

## Interactive Script
1) Ensure AWS CLI is configured
2) Execute `git clone https://github.com/aaron-dm-mcdonald/automate-ec2-creation/blob/main/create-ec2-input.sh` to grab the script. 
3) If using windows you may want to verify end of line chars/encoding is correct in something like VS Code. 
4) Execute `chmod +x create-ec2-input.sh` to make it executable. 
5) Execute `./create-ec2-input.sh` to launch the script. 
6) Be prepared for user input for region, security group, and key pair name. 