```shell
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo install minikube /usr/local/bin
download kubectl and put it into path
 eval $(minikube docker-env)
 minikube dashboard
https_proxy=http://192.169.1.5:1088 minikube start --docker-env http_proxy=http://192.169.1.5:1088 --docker-env https_proxy=http://192.169.1.5:1088 --docker-env no_proxy=192.168.99.0/24
 Unable to pull images, which may be OK: running cmd: sudo kubeadm config images pull --config /var/lib/kubeadm.yaml: command failed: sudo kubeadm config images pull --config /var/lib/kubeadm.yaml
ssh -N -L 31882:204.104.1.154:31882 ft1-jump
```

