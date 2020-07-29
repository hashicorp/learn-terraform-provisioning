#!/bin/bash
set -e
# Updating and Upgrading dependencies
sudo apt-get update -y -qq && sudo apt-get upgrade -y -qq

# Install necessary dependencies
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update -y -qq
sudo apt -y -qq install golang-go

# Setup sudo to allow no-password sudo for "hashicorp" group and adding "terraform" user
sudo groupadd -r hashicorp
sudo useradd -m -s /bin/bash terraform
sudo usermod -a -G hashicorp terraform
sudo cp /etc/sudoers /etc/sudoers.orig
echo "terraform  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform

# Installing SSH key
sudo mkdir -p /home/terraform/.ssh
sudo chmod 700 /home/terraform/.ssh
sudo cp /tmp/newkey.pub /home/terraform/.ssh/authorized_keys
sudo chmod 600 /home/terraform/.ssh/authorized_keys
sudo chown -R terraform /home/terraform/.ssh
sudo usermod --shell /bin/bash terraform

# Create GOPATH for Terraform user & download the webapp from github


sudo -i -u terraform bash << EOF
whoami
cd /home/terraform
export PATH=$PATH:/usr/local/go/bin
sudo go get github.com/hashicorp/learn-go-webapp-demo
EOF
