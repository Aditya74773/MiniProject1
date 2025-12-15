pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS = '-no-color'
        // SSH_CRED_ID is not needed for destruction
    }

    stages {
        stage('Terraform Destruction') { // Changed stage name
            steps {
                // Use withCredentials to inject AWS credentials
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        bat 'terraform init'

                        // 1. Run terraform plan -destroy to show what will be removed
                        bat 'terraform plan -destroy -out=tfdestroyplan'

                        // 2. Execute terraform destroy, automatically approving the plan
                        bat 'terraform destroy -auto-approve'
                        
                        // NOTE: Outputs and environment variable setting steps are removed
                        // as they are not needed for destruction.
                    }
                }
            }
        }
        
        // REMOVED: Wait for AWS Instance Status stage
        // REMOVED: Ansible Configuration stage
    }

    post {
        always {
            // Nothing to clean up since the inventory file was not created.
        }
    }
}