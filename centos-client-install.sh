#!/bin/bash

# Update the apt packages and get a couple of basic tools
sudo dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y
sudo dnf distro-sync -y

sudo dnf update -y
sudo dnf install bind-utils unzip curl vim jq java-11-openjdk-devel -y



# Install Docker Community Edition
echo "Docker Install Beginning..."
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce --nobest -y
## Configure Docker to be run as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version
sudo service docker restart

echo "Consul Install Beginning..."

sudo dnf config-manager --add-repo=https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install consul -y

sudo rm -rf /etc/consul.d/consul.hcl
sudo cp /vagrant/config/consul/client/consul.hcl /etc/consul.d/. 

echo "node_name = \"$(hostname)\"" > /etc/consul.d/nodename.hcl

sudo systemctl daemon-reload
sudo systemctl enable consul
sudo systemctl restart consul  
