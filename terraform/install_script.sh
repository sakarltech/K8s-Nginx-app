#!/bin/bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Download Minikube
sudo curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64

# Make Minikube executable
sudo chmod +x minikube-linux-amd64

# Install Minikube to /usr/local/bin
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Add user to docker group (optional, but recommended to avoid using sudo with docker)
sudo usermod -aG docker $USER
newgrp docker

# Start Minikube (using the docker driver)
minikube start --driver=docker

echo "Minikube installation complete!"
echo "You may need to log out and back in or run 'newgrp docker' for docker group changes to take effect."
echo "To interact with your cluster, use 'kubectl'."

# Install kubectl utility
# Download latest reslease
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client