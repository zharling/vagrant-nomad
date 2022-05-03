#!/bin/bash

# Update the apt packages and get a couple of basic tools
sudo dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y
sudo dnf distro-sync -y

sudo dnf update -y
sudo dnf install unzip curl vim jq java-11-openjdk-devel -y



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
sudo cp /vagrant/config/consul/consul.hcl /etc/consul.d/. 

echo "node_name = \"$(hostname)\"" > /etc/consul.d/nodename.hcl

sudo systemctl daemon-reload
sudo systemctl enable consul
sudo systemctl restart consul  



echo "Nomad Install Beginning..."
sudo dnf config-manager --add-repo=https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install nomad -y

sudo rm -rf /etc/nomad.d/nomad.hcl
sudo cp /vagrant/config/nomad/nomad.hcl /etc/nomad.d/.
echo "name = \"$(hostname)\"" > /etc/nomad.d/nodename.hcl


usermod -a -G docker nomad

sudo systemctl daemon-reload
sudo systemctl enable nomad
sudo systemctl restart nomad 

