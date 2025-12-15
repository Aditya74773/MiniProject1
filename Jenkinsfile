pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_VERSION = '1.0.0'
    }

    stages {
        // ... (Checkout stage remains the same)

        stage('Terraform Init') {
            steps {
                bat 'terraform init' // Changed from sh to bat
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate' // Changed from sh to bat
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan -out=tfplan' // Changed from sh to bat
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform changes?', ok: 'Apply'
                bat 'terraform apply tfplan' // Changed from sh to bat
            }
        }

        // ... (Ansible stages remain the same, assuming the Ansible plugin is installed)
    }

    // ... (post section remains the same)
}