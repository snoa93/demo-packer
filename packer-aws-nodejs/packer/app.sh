#!/bin/bash

# Wait for EC2 to spin up
sleep 30

# Install packages
sudo yum update -y

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

# Setup app
sudo yum install unzip -y
cd ~/ && unzip cocktails.zip
cd ~/app && npm i --only=prod

# Systemd
sudo mv /tmp/cocktails.service /etc/systemd/system/cocktails.service
sudo systemctl enable cocktails.service
sudo systemctl start cocktails.service
