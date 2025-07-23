pipeline {
  agent any
  environment {
    AWS_DEFAULT_REGION = 'us-east-1'
    ECR_REPO = ''
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('SonarQube') {
      steps { sh 'sonar-scanner -Dsonar.projectKey=DevOpsApp -Dsonar.sources=.' }
    }
    stage('Build & Push Docker') {
      steps {
        script {
          ECR_REPO = sh(script: "terraform -chdir=terraform output -raw ecr_repo_url", returnStdout: true).trim()
        }
        sh 'aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REPO'
        sh 'docker build -t $ECR_REPO:latest .'
        sh 'docker push $ECR_REPO:latest'
      }
    }
    stage('Terraform Apply') {
      steps { sh 'terraform -chdir=terraform init && terraform apply -auto-approve' }
    }
    stage('Ansible Configure') {
      steps { sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml' }
    }
    stage('K8S Deploy') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh 'kubectl apply -f k8s/deployment.yml && kubectl apply -f k8s/service.yml'
        }
      }
    }
  }
}
