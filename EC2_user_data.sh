#!/bin/bash
# set -e: If any command in the script fails (exits with a non-zero status), the shell will terminate the script immediately.
set -e

# Install the CodeDeploy agent
yum update -y
yum install -y ruby
cd /home/ec2-user
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
./install auto

# Start the CodeDeploy agent
service codedeploy-agent start
chkconfig codedeploy-agent on