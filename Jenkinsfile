pipeline {
    agent any

    environment {
        // Your Docker Hub username and repository name
        DOCKER_IMAGE = 'uday2097/trend:latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls code from your main branch
                git branch: 'main', url: 'https://github.com/sankaruday/Trend-DevOps-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Builds the image using the Dockerfile in your root directory
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Uses the 'docker-hub-creds' you created in Jenkins UI
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // Uses the 'aws-access-key' and 'aws-secret-key' from your Jenkins UI
                    withCredentials([
                        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh """
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        
                        # Connect to your cluster in Mumbai region
                        aws eks update-kubeconfig --region ap-south-1 --name trend-eks-cluster
                        
                        # Apply the deployment.yaml located in your root folder
                        kubectl apply -f .
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful! Your 'Trend' app is now running on EKS."
        }
        failure {
            echo "Deployment Failed. Check the console logs for errors."
        }
    }
}
