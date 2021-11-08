#!/usr/bin/env bash

set +e

cd ~/
echo base packages
pwd

echo Pre-req for docker
sudo apt install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg2
source /etc/os-release
curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list

echo docker install
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo add docker to user group
sudo usermod -aG docker $USER
sudo mkdir /mnt/wsl/shared-docker/

echo set some env vars in the bash profile - the following coming from the dockerhostfragment.txt
# DOCKER_DISTRO="Ubuntu"
# DOCKER_DIR=/mnt/wsl/shared-docker
# DOCKER_SOCK="$DOCKER_DIR/docker.sock"
# export DOCKER_HOST="unix://$DOCKER_SOCK"

curl -fsSL https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/dockerhostfragment.txt 2>&1 | tee -a ~/.bashrc

echo "alias k=kubectl" | tee -a ~/.bash_aliases

sudo curl -o /etc/docker/daemon.json --create-dirs https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/daemon.json

echo minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo apt install -y minikube-linux-amd64 /usr/local/bin/minikube

echo "helm - from helm docs - https://helm.sh/docs/intro/install/#from-apt-debianubuntu"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

#install dapr
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

