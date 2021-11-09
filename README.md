# Docker, Kubernetes, Minukube, Dapr and helm inside wsl2 ubuntu
Setting up docker, kubernetes, minikube, dapr and helm inside wsl2 Ubuntu

## Pre-requisites
1. WSL2 feature enabled in Windows.
1. Uninstall Docker Desktop
1. Uninstall Minikube for Windows
1. (Recommended) Install Windows Terminal

### Clean up existing WSL Option 1
1. At a bash prompt: `sudo apt remove docker docker-engine docker.io container`

### Clean up existing WSL Option 2 (Nuke!)
> Caution this will delete your Ubuntu WSL and all data for it (takes only seconds)
1. From admin powershell `wsl --unregister Ubuntu`
1. From admin powershell `wsl --install -d Ubuntu` to get a clean ubuntu distro in WSL2. Don't close your powershell session after - you'll need it.
1. When prompted, create your user and password. It doesn't need to be the same as windows
1. When at the `$` prompt you will need to update the distro with the latest packages which will take about 5 mins: `sudo apt update && sudo apt upgrade -y`
1. Shutdown WSL from your powershell session `wsl --shutdown`
1. Run an ubuntu console or open from Windows Terminal if you have it (recommended)
1. at the prompt: `sudo wget -q https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/everything.sh -O - | /bin/bash` (5 mins)
1. When finished, at the $ prompt: `nohup sudo -b dockerd`
1. Load a new bash session (if in terminal simply open another ubuntu tab)
1. `sudo wget -q https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/start.sh -O - | /bin/bash`

You should now have a running docker, minikube and helm.
