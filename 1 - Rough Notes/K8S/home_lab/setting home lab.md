K3S:

curl -sfL https://get.k3s.io | sh -


change kube config for running from user without root:

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
chmod 600 ~/.kube/config
# To ensure both standard kubectl and the k3s kubectl wrapper point to this file, add this line to your shell configuration:
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
source ~/.bashrc

added kubectl auto complete
sudo apt install bash-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc


