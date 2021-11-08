set +e
echo "starting minikube"
minikube start

echo "*** init dapr"
dapr init -k
