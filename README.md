
Project Documentation: Trendify DevOps Pipeline

1. Pipeline Explanation
The CI/CD pipeline is designed to automate the journey from code commit to a live, monitored production environment on AWS EKS.

Stage 1: Checkout Code –  pulls the latest source code from the GitHub repository.

Stage 2: Build Docker Image – A production Docker image is created using the Dockerfile. It uses nginx:stable-alpine to serve the React application efficiently.

Stage 3: Push to Docker Hub – The built image is tagged and pushed to the Docker Hub registry (uday2097/trend) using Jenkins credentials.

Stage 4: Deploy to EKS – Jenkins authenticates with AWS, updates the kubeconfig, and applies the Kubernetes manifests (deployment.yaml). This stage creates the LoadBalancer that provides the public URL.

Setup Instructions

Prerequisites

AWS CLI & kubectl installed on  management server.

eksctl installed for cluster scaling and management.

Helm installed for the monitoring stack.

Jenkins with Docker and Pipeline plugins.

Step 1: Infrastructure Setup (EKS)
Create the cluster using eksctl. Note that for monitoring, we scaled the cluster to 2 nodes to accommodate the Prometheus stack.

eksctl create cluster --name trend-eks-cluster --region ap-south-1 --nodegroup-name standard-nodes --nodes 2 --instance-types t3.small

Step 2: Jenkins Configuration

Credentials: Add the following credentials in Jenkins:

docker-hub-creds: Username/Password for Docker Hub.

aws-access-key: AWS Access Key ID (Secret text).

aws-secret-key: AWS Secret Access Key (Secret text).

Pipeline: Create a "Pipeline" job and point it to your GitHub repository URL.

Step 3: Application Deployment

Run the Jenkins pipeline. This will deploy the application. To find your live URL, run:


kubectl get svc
Use the EXTERNAL-IP (LoadBalancer DNS) to view the Trendify website.

Step 4: Monitoring Setup (Prometheus & Grafana)
Add the Helm repository:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

Install the stack:

kubectl create namespace monitoring
helm install monitoring-stack prometheus-community/kube-prometheus-stack --namespace monitoring
Access Grafana via LoadBalancer:


kubectl edit svc monitoring-stack-grafana -n monitoring 


Deployment Artifacts
Application URL: aab6f920fe87a4cd88312c16b6c77c4b-360898684.ap-south-1.elb.amazonaws.com

Monitoring URL: a69cac10a0c7b4fcb91ea3414c016943-328888065.ap-south-1.elb.amazonaws.com

Docker Image: uday2097/trend:latest
