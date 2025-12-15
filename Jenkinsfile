pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'  // Adjust as needed
        TF_VERSION = '1.0.0'  // Specify Terraform version
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform changes?', ok: 'Apply'
                sh 'terraform apply tfplan'
            }
        }

        stage('Ansible Deploy Grafana') {
            steps {
                ansiblePlaybook(
                    playbook: 'grafana_playbook.yml',
                    inventory: 'inventory.ini'
                )
            }
        }

        stage('Ansible Deploy Prometheus') {
            steps {
                ansiblePlaybook(
                    playbook: 'prometheus.yml',  // Assuming this is a playbook, adjust if it's config
                    inventory: 'inventory.ini'
                )
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'apply_log.txt', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}