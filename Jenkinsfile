pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS = '-no-color'
        // SSH_CRED_ID is not needed for destruction
    }

    stages {
        stage('Terraform Destruction') { // Stage name changed
            steps {
                // Use withCredentials to inject AWS credentials
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        bat 'terraform init'

                        // EXECUTE DESTRUCTION
                        // This command destroys all resources defined in your Terraform configuration
                        bat 'terraform destroy -auto-approve'
                        
                        echo 'Terraform destruction completed.'
                        
                        // REMOVED: All steps related to extracting IPs, Instance IDs, and creating inventory files.
                    }
                }
            }
        }
        
        // REMOVED: Wait for AWS Instance Status stage
        // REMOVED: Ansible Configuration stage
    }

    post {
        always {
            steps {
                // No need to delete dynamic_inventory.ini as it was not created.
                // Added 'steps' block to satisfy Declarative Pipeline syntax requirement.
            }
        }
    }
}