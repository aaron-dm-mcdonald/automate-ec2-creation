# automate-ec2-creation

## Manual EC2 Creation Steps

1) Figure out what data you need to run the `aws ec2 run-instances` command
2) Verify the CLI is configured (`aws configure`), you have a region chosen, etc
3) NOT DONE YET

## Basic script (no input or variables) 
1) NOT IN REPO YET! 

## Interactive Script
1) Ensure AWS CLI is configured
2) Execute `git clone https://github.com/aaron-dm-mcdonald/automate-ec2-creation/blob/main/create-ec2-input.sh` to grab the script. 
3) If using windows you may want to verify end of line chars/encoding is correct in something like VS Code. 
4) Execute `chmod +x create-ec2-input.sh` to make it executable. 
5) Execute `./create-ec2-input.sh` to launch the script. 
6) Be prepared for user input for region, security group, and key pair name. 