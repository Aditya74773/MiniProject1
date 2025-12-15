pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS = '-no-color'
        SSH_CRED_ID = 'aws-deployer-ssh-key'
        // TF_CLI_CONFIG_FILE = credentials('aws-creds') // REMOVED: Incorrect usage
    }

    stages {
        stage('Terraform Provisioning') {
            steps {
                // Use withCredentials to inject AWS credentials as environment variables
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        // All 'sh' commands must be changed to 'bat' if running on a Windows Agent
                        bat 'terraform init'
                        bat 'terraform apply -auto-approve'

                        // 1. Extract Public IP Address
                        env.INSTANCE_IP = bat(
                            script: 'terraform output -raw instance_public_ip',
                            returnStdout: true
                        ).trim()

                        // 2. Extract Instance ID
                        env.INSTANCE_ID = bat(
                            script: 'terraform output -raw instance_id',
                            returnStdout: true
                        ).trim()

                        echo "Provisioned Instance IP: ${env.INSTANCE_IP}"
                        echo "Provisioned Instance ID: ${env.INSTANCE_ID}"

                        // 3. Create dynamic inventory file
                        // Note: Using 'bat' for this requires double quotes around the IP in the echo command.
                      //  bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
                    }
                }
            }
        }

        stage('Wait for AWS Instance Status') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo "Waiting for instance ${env.INSTANCE_ID} to pass AWS health checks..."

                    // 1. Region Mismatch: The previous log showed AWS_DEFAULT_REGION was 'us-east-1'.
                    //    The previous run showed the wait command was 'us-east-2'. This must be consistent.
                    // 2. Shell Fix: Use 'bat' command.
                    bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1" // Corrected region to us-east-1 (assuming it's correct)

                    echo 'AWS instance health checks passed. Proceeding to Ansible.'
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                // This stage remains correct, as the Ansible plugin handles SSH cred injection
                ansiblePlaybook(
                    playbook: 'playbooks/grafana.yml',
                    inventory: 'dynamic_inventory.ini',
                    credentialsId: SSH_CRED_ID,
                )
            }
        }
    }

    post {
        always {
            // Use 'bat' for file removal on Windows
            bat 'del /f dynamic_inventory.ini'
        }
    }
}