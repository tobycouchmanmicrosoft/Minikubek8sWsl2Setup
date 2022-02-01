# Docker, Kubernetes, Minukube, Dapr and helm inside wsl2 ubuntu

Use the following guide to set up Docker, Kubernetes, Dapr, and helm running in Minikube on the Ubuntu Linux distro running inside Windows Subsystem for Linux 2 (wsl2).

## Pre-requisites
1. WSL2 feature enabled in Windows. (https://docs.microsoft.com/en-us/windows/wsl/setup/environment)
2. Run `wsl --set-default-version 2` to ensure new distro installations use WSL 2 rather than WSL 1 (the default).
3. Uninstall Docker Desktop
4. Uninstall Minikube for Windows
5. (Recommended) Install Windows Terminal

### Clean up existing WSL Option 1
> Try this if you've already used Docker Desktop integrated with WSL2 + Kubernetes. In many cases it may be cleaner to follow option 2 below.
1. At a bash prompt: `sudo apt remove docker docker-engine docker.io container`

### Clean up existing WSL Option 2 (Nuke!)
> Caution this will delete your Ubuntu WSL and all data for it (takes only seconds), so be careful to move any data from your existing distro that you want to keep before doing this.
1. From admin powershell `wsl --unregister Ubuntu`.
1. From admin powershell `wsl --install -d Ubuntu` to get a clean ubuntu distro in WSL2. Don't close your powershell session after - you'll need it.
1. When prompted, create your user and password. It doesn't need to be the same as windows.
1. When at the `$` prompt you will need to update the distro with the latest packages which will take about 5 mins: `sudo apt update && sudo apt upgrade -y`. You will be prompted for the password you created in step 3.
1. We need to restart WSL at this point, so first shut down WSL from your powershell session `wsl --terminate Ubuntu`
1. Run an ubuntu console or open from Windows Terminal if you have it (recommended) and open an Ubuntu tab. This will restart WSL.
1. at the `$` prompt: `sudo wget -q https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/everything.sh -O - | /bin/bash` (5 mins). You will be prompted for your password. This installs Docker, Minikube, Kubectl, Dapr and Helm. An alias for the 'kubectl' command is added so that you can invoke it with `k`, e.g. `k get all` instead of `kubectl get all`.
1. When finished, at the $ prompt: `nohup sudo -b dockerd`. This should start up docker - in doing so it will write log text to standard out but should then return you to a prompt. Ignore warning messages about 'nohup'.
1. Load a new bash session (if in terminal simply open another ubuntu tab)
1. `sudo wget -q https://raw.githubusercontent.com/tobycouchmanmicrosoft/Minikubek8sWsl2Setup/main/start.sh -O - | /bin/bash` This should start minikube and enable dapr inside the minikube cluster. (3 mins).

You should now have a running Docker, Minikube, Dapr and Helm.

### Verify
1. Verify that docker is up and running with the following command: $`docker images` - no errors should be reported.
1. Verify that kubernetes is up and running in minikube with the following command $`k get all` which should return the service/kubernetes service. 
   > Note that this is the same as typing $`kubectl get all` with the kubectl aliased to 'k' for your convenience as part of step 7 above.
1. Verify dapr status with $`dapr status -k`
1. Initially there won't be any helm charts installed, but the $`helm list` command should return an empty list.

### Notes
1. If you restart your linux distro ($`wsl --shutdown` or `wsl --terminate ubntu`) you can restart both docker and minikube with the following command `nohup sudo -b dockerd && minikube start`
1. If you are building your docker images within WSL, you'll need to do this first: `eval $(minikube docker-env)`. This points the docker cli to the docker instance running in minikube. If you do not do this then when you deploy a helm chart, kubernetes will not be able to find the docker image.
1. You may find it more convenient to 'permanently' point your docker client to the instance running in minikube so that you don't have to run the above eval statement for every new session. If so, just run `minikube docker-env` which will output the export commands to set the required environment variables. Simply copy those lines to the bottom of your ~/.bashrc file, and either run your profile again `source ~/.bashrc` or close/re-open a new bash terminal.
