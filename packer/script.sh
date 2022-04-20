#!/usr/bin/env bash
echo "waiting 180 seconds for cloud-init to update /etc/apt/sources.list"
timeout 180 /bin/bash -c \
  'until stat /var/lib/cloud/instance/boot-finished 2>/dev/null; do echo waiting ...; sleep 1; done'
echo "running apt-get update ..."
cat /etc/apt/sources.list
sudo -E apt-get update

# Install Docker
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Get the Docker repo GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker Ubuntu repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get -y upgrade
sudo apt-get -y install docker-ce
sudo apt-get -y install bash-completion

# Install Netdata
wget https://my-netdata.io/kickstart.sh
bash kickstart.sh

# # Install Apps
# sudo docker run --restart always --detach --name nginx -p 8000:80 nginx
# sudo docker run --restart always --detach --name webapp -p 8001:80 yeasy/simple-web
