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
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}"
                    sh "kubectl apply -f deployment.yaml"
                }
            }
        }
    }
}
