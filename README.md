# Kubernetes Nginx Deployment Demo

This project will guide you through:

Terraform Infrastructure: Provisioning a basic AWS environment (VPC, EC2 instance) to host our Minikube cluster.
Minikube Setup: Installing and configuring Minikube on the EC2 instance for local Kubernetes development.
Kubernetes Manifests: Defining Kubernetes objects to deploy and manage an Nginx application.
Deployment: Deploying the Nginx application to the Minikube cluster.
Service: Exposing the Nginx application to the outside world.
ConfigMap: Managing Nginx configuration.
Secret: Managing sensitive data (though not explicitly used in this basic Nginx setup, we'll include a placeholder).
Ingress: Setting up ingress rules to route traffic to the Nginx service.


This project demonstrates a simple Kubernetes deployment of an Nginx web server. It showcases various Kubernetes objects to help students understand how Kubernetes orchestrates application deployments. This setup uses Terraform to provision an EC2 instance on AWS and installs Minikube to create a local Kubernetes cluster.

## Project Overview

The project includes the following components:

*   **Terraform:** Infrastructure as Code (IaC) to provision an EC2 instance on AWS and configure it to run Minikube.
*   **Kubernetes:** A set of manifest files that define a simple Nginx deployment, service, configmap, and secret.
*   **Nginx:** A popular web server used as the deployed application.

## Prerequisites

Before you begin, ensure you have the following:

*   An AWS account with the necessary permissions to create EC2 instances.
*   Terraform installed on your local machine.
*   AWS CLI installed and configured on your local machine.
*   An SSH key pair for accessing the EC2 instance.

## Step-by-Step Instructions

Follow these steps to deploy the project:

### 1. Clone the Repository

Clone this GitHub repository to your local machine:

```bash
git clone <repository_url>
cd <repository_directory>
```
### 2. Configure AWS Credentials

Set up your AWS credentials as environment variables or using the AWS CLI:

```bash
export AWS_ACCESS_KEY_ID=<your_aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<your_aws_secret_access_key>
export AWS_REGION=<your_aws_region> #e.g., us-west-2
```

Or, configure using the AWS CLI:

```bash
aws configure
```

### 3. Configure Terraform Variables

In the `terraform/variables.tf` file, update the following variables:

* `aws_region`: Set your desired AWS region.
* `instance_type`: Choose an appropriate EC2 instance type (e.g., `t2.medium`).
* `key_name`: Set the name of your SSH key pair in AWS.

### 4. Initialize Terraform

Navigate to the `terraform` directory and initialize Terraform:

```bash
cd terraform
terraform init
```

### 5. Apply Terraform Configuration

Apply the Terraform configuration to create the EC2 instance and install Minikube:

```bash
terraform apply -auto-approve
```

### 6. SSH into the EC2 Instance

After Terraform creates the EC2 instance, get the public IP address from the Terraform output and SSH into the instance using your key pair:

```bash
ssh -i <your_key>.pem ec2-user@<public_ip>
```

### 7. Verify Minikube is Running

Once connected to the EC2 instance, verify that Minikube is running by executing:

```bash
kubectl cluster-info
```

If Minikube is running correctly, you should see information about the Kubernetes cluster.

### 8. Deploy Nginx to Kubernetes

Apply the Kubernetes manifests to deploy Nginx. First, create the `nginx-demo` namespace:

```bash
kubectl create namespace nginx-demo
```

Then, apply the remaining manifests:

```bash
kubectl apply -f kubernetes/deployment.yml
kubectl apply -f kubernetes/service.yml
kubectl apply -f kubernetes/configmap.yml
kubectl apply -f kubernetes/secret.yml
```

### 9. Access the Nginx Service

To access the Nginx service, you'll need to determine the NodePort assigned to the service. Run the following command:

```bash
kubectl get service nginx-service -n nginx-demo
```

Look for the `PORT(S)` column in the output. It will show a port mapping like `80:30000/TCP`. The `30000` is the NodePort.

Now, access the Nginx service in your web browser using the EC2 instance's public IP and the NodePort:

```
http://<ec2_public_ip>:<node_port>
```

You should see the default Nginx welcome page.

## Kubernetes Objects Explained

This project utilizes the following Kubernetes objects:

* **Namespace:** Provides a way to logically isolate resources within the cluster.
* **Deployment:** Manages the deployment of Nginx pods, ensuring the desired number of replicas are running.
* **Service:** Exposes the Nginx deployment, allowing access to the application.
* **ConfigMap:** Provides configuration data to the Nginx pods.
* **Secret:** Stores sensitive information, such as API keys, used by the Nginx pods.

## Troubleshooting

* **AWS Permissions:** Ensure that the AWS credentials used by Terraform have the necessary permissions to create EC2 instances.
* **SSH Connectivity:** Verify that you can SSH into the EC2 instance using the specified key pair.
* **Minikube Issues:** If Minikube fails to start, check the Minikube logs for errors.
* **Kubernetes Deployment Issues:** Use `kubectl` to inspect the status of the pods, services, and deployments.

## Contributing

Contributions are welcome! Please submit a pull request with your changes.
