#!/usr/bin/env bash

set +e

cd ~/

echo "updating packages"
sudo apt update && sudo apt upgrade -y

echo base packages
pwd

echo ***Pre-req for docker
sudo apt install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg2
source /etc/os-release
curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list

echo "***docker install"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "***add docker to user group"
sudo usermod -aG docker $USER
sudo mkdir -p -- /mnt/wsl/shared-docker/

# need to also add the above mkdir to the bashrc because if the wsl distro is shutdown the directory might be deleted
sudo echo "mkdir -p -- /mnt/wsl/shared-docker/" | tee -a ~/.bashrc

echo "***set some env vars in the bash profile"
sudo curl -fsSL https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/dockerhostfragment.txt 2>&1 | tee -a ~/.bashrc

echo "alias k=kubectl" | tee -a ~/.bash_aliases

sudo curl -o /etc/docker/daemon.json --create-dirs https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/daemon.json

echo "***installing minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

echo "***installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "***helm - from helm docs - https://helm.sh/docs/intro/install/#from-apt-debianubuntu"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

echo "***install dapr"
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

echo "configure git"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
git config --global credential.https://dev.azure.com.useHttpPath true
test -f "/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe" || echo "git credential manager core doesn't exist - follow instructions at https://github.com/GitCredentialManager/git-credential-manager#option-2-install-from-source-helper-script"

echo "***install Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "starting docker"

nohup sudo -b dockerd

sleep 10

echo -e "\e[1;36mYOU MUST NOW OPEN A NEW TERMINAL BEFORE STARTING MINIKUBE \e[0m"