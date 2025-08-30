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
