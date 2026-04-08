pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'uday2097'
        DOCKER_HUB_REPO = 'trend'
        DOCKER_HUB_CREDS = 'docker-hub-creds' // Must match the ID you just made in Jenkins
        AWS_REGION = 'ap-south-1'
        EKS_CLUSTER_NAME = 'trend-eks-cluster'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/sankaruday/Trend-DevOps-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}:latest ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDS}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}:latest"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // This pulls the keys you saved in Jenkins Manage Credentials
                    withCredentials([
                        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh """
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        aws eks update-kubeconfig --region ap-south-1 --name trend-eks-cluster
                        kubectl apply -f k8s/
                        """
                    }
                }
            }
        }
