echo "starting docker"
sudo /mnt/c/Windows/System32/wsl.exe -d ubuntu sh -c "nohup sudo -b dockerd < /dev/null > /mnt/wsl/shared-docker/dockerd.log 2>&1"

echo "starting minikube"
minikube start

echo "*** init dapr"
dapr init -k
