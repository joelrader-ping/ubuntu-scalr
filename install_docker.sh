#!/bin/bash
echo "This script installs Docker and Docker compose on Ubuntu 18.04 baseline"
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common docker-ce docker-ce-cli containerd.io -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable" 
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
sudo groupadd docker
sudo usermod -aG docker $USER
docker-compose --version
echo "Complete. Reboot then sudo systemctl enable docker to finish install"
