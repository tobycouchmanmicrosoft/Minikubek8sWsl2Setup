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
1. When at the `$` prompt you will need to update the distro with the latest packages which will take about 5 mins: `sudo apt update && sudo apt upgrade -y`. You will be prompted for the password you created in step 3.
1. We need to restart WSL at this point, so first shut down WSL from your powershell session `wsl --shutdown`
1. Run an ubuntu console or open from Windows Terminal if you have it (recommended). This will restart WSL.
1. at the `$` prompt: `sudo wget -q https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/everything.sh -O - | /bin/bash` (5 mins). You will be prompted for your password. This installs Docker, Minikube, Kubectl, Dapr and Helm. An alias for the 'kubectl' command is added so that you can invoke it with `k`, e.g. `k get all` instead of `kubectl get all`.
3. When finished, at the $ prompt: `nohup sudo -b dockerd`. This will start up
4. Load a new bash session (if in terminal simply open another ubuntu tab)
5. `sudo wget -q https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/start.sh -O - | /bin/bash` (3 mins).

You should now have a running Docker, Minikube, Dapr and Helm.

### Verify
1. Verify that kubernetes is up and running in minikube with the following command $`k get all` which should return the service/kubernetes service.
2. Verify dapr status with $`dapr status -k`
3. Initially there won't be any helm charts installed, but the $`helm list` command should return an empty list.

### Notes
1. If you restart your linux distro ($`wsl --shutdown`) you can restart both docker and minikube with the following command `nohup sudo -b dockerd && minikube start`
