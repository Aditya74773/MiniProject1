// pipeline {



//     agent any







//     environment {



//         TF_IN_AUTOMATION = 'true'



//         TF_CLI_ARGS = '-no-color'



//         SSH_CRED_ID = 'Aadii_id'



//         // TF_CLI_CONFIG_FILE = credentials('aws-creds') // REMOVED: Incorrect usage



//     }







//     stages {



//         stage('Terraform Provisioning') {



//             steps {



//                 // Use withCredentials to inject AWS credentials as environment variables



//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {



//                     script {



//                         // All 'sh' commands must be changed to 'bat' if running on a Windows Agent



//                         bat 'terraform init'



//                         bat 'terraform apply -auto-approve'







//                         // 1. Extract Public IP Address



//                         env.INSTANCE_IP = bat(



//                             script: 'terraform output -raw instance_public_ip',



//                             returnStdout: true



//                         ).trim()







//                         // 2. Extract Instance ID



//                         env.INSTANCE_ID = bat(



//                             script: 'terraform output -raw instance_id',



//                             returnStdout: true



//                         ).trim()







//                         echo "Provisioned Instance IP: ${env.INSTANCE_IP}"



//                         echo "Provisioned Instance ID: ${env.INSTANCE_ID}"







//                         // 3. Create dynamic inventory file



//                         // Note: Using 'bat' for this requires double quotes around the IP in the echo command.



//                         bat 'echo %INSTANCE_IP% >> dynamic_inventory.ini'



//                     }



//                 }



//             }



//         }







//         stage('Wait for AWS Instance Status') {



//             steps {



//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {



//                     echo "Waiting for instance ${env.INSTANCE_ID} to pass AWS health checks..."







//                     // 1. Region Mismatch: The previous log showed AWS_DEFAULT_REGION was 'us-east-1'.



//                     //    The previous run showed the wait command was 'us-east-2'. This must be consistent.



//                     // 2. Shell Fix: Use 'bat' command.



//                     bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1" // Corrected region to us-east-1 (assuming it's correct)







//                     echo 'AWS instance health checks passed. Proceeding to Ansible.'



//                 }



//             }



//         }







//         stage('Ansible Configuration') {



//             steps {



//                 // This stage remains correct, as the Ansible plugin handles SSH cred injection



//                 ansiblePlaybook(



//                     playbook: 'playbooks/grafana.yml',



//                     inventory: 'dynamic_inventory.ini',



//                     credentialsId: SSH_CRED_ID,



//                 )



//             }



//         }



//     }

//     post {



//         always {



//             // Use 'bat' for file removal on Windows



//             bat 'del /f dynamic_inventory.ini'



//         }



//     }



// }

// pipeline {

//     agent any

//     environment {
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         SSH_CRED_ID = 'Aadii_id'
//     }

//     stages {

//         stage('Terraform Provisioning') {
//             steps {
//                 // Securely inject AWS credentials
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     script {
//                         // Core Terraform commands remain as bat
//                         bat 'terraform init'
//                         bat 'terraform apply -auto-approve'

//                         // 1. Extract Public IP Address (FIXED: Using powershell for clean output)
//                         env.INSTANCE_IP = powershell(
//                             script: 'terraform output -raw instance_public_ip',
//                             returnStdout: true
//                         ).trim()

//                         // 2. Extract Instance ID (FIXED: Using powershell for clean output)
//                         env.INSTANCE_ID = powershell(
//                             script: 'terraform output -raw instance_id',
//                             returnStdout: true
//                         ).trim()

//                         echo "Provisioned Instance IP: ${env.INSTANCE_IP}"
//                         echo "Provisioned Instance ID: ${env.INSTANCE_ID}"

//                         // 3. Create dynamic inventory file
//                         // Uses Groovy interpolation (double quotes) for the clean variable
//                         bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
//                     }
//                 }
//             }
//         }

//         stage('Wait for AWS Instance Status') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     echo "Waiting for instance ${env.INSTANCE_ID} to pass AWS health checks..."

//                     // AWS CLI wait command uses the clean env.INSTANCE_ID variable
//                     bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1" 

//                     echo 'AWS instance health checks passed. Proceeding to Ansible.'
//                 }
//             }
//         }

//         stage('Ansible Configuration') {
//             steps {
//                 // FIXED: Direct Ansible plugin use removed. Executing via WSL on Windows agent.
//                 // Note: SSH key must be configured correctly for the user within WSL.
//                 bat "wsl ansible-playbook -i dynamic_inventory.ini grafana_playbook.yml"
//             }
//         }
//     }

//     post {
//         always {
//             steps {
//                 // Use 'bat' for file removal on Windows
//                 bat 'del /f dynamic_inventory.ini'
//             }
//         }
//     }
// }


// pipeline {

//     agent any

//     environment {
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         // SSH_CRED_ID is not needed for destruction
//     }

//     stages {

//         stage('Terraform Destruction') {
//             steps {
//                 // Securely inject AWS credentials for Terraform
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     script {
//                         bat 'terraform init'

//                         // EXECUTE DESTRUCTION
//                         // This command destroys all resources managed by Terraform
//                         bat 'terraform destroy -auto-approve'
                        
//                         echo 'Terraform destruction completed.'
                        
//                         // REMOVED: All steps related to extracting outputs and creating inventory files.
//                     }
//                 }
//             }
//         }
        
//         // REMOVED: Wait for AWS Instance Status stage
//         // REMOVED: Ansible Configuration stage
//     }

//     post {
//         always {
//             steps {
//                 // Ensure the 'steps' block is present even if empty.
//             }
//         }
//     }
// }

// pipeline {

//     agent any

//     environment {
//         // Terraform environment variables
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         // Jenkins credential ID for SSH (though we use a specific key path later)
//         SSH_CRED_ID = 'Aadii_id' 
//     }

//     stages {

//         stage('Terraform Provisioning') {
//             steps {
//                 // Securely inject AWS credentials using the Jenkins 'AWS_Aadii' credential ID
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     script {
//                         // Core Terraform commands (assuming Windows agent running BAT/PowerShell)
//                         bat 'terraform init'
//                         bat 'terraform apply -auto-approve'

//                         // 1. Extract Public IP Address 
//                         env.INSTANCE_IP = powershell(
//                             script: 'terraform output -raw instance_public_ip',
//                             returnStdout: true
//                         ).trim()

//                         // 2. Extract Instance ID
//                         env.INSTANCE_ID = powershell(
//                             script: 'terraform output -raw instance_id',
//                             returnStdout: true
//                         ).trim()

//                         echo "Provisioned Instance IP: ${env.INSTANCE_IP}"
//                         echo "Provisioned Instance ID: ${env.INSTANCE_ID}"

//                         // 3. Create dynamic inventory file for Ansible
//                         bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
//                     }
//                 }
//             }
//         }

//         stage('Wait for AWS Instance Status') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     echo "Waiting for instance ${env.INSTANCE_ID} to pass AWS health checks..."

//                     // AWS CLI wait command uses the environment variable
//                     bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1" 

//                     echo 'AWS instance health checks passed. Proceeding to Ansible.'
//                 }
//             }
//         }

//         stage('Ansible Configuration') {
//             steps {
//                 // *** FIX APPLIED HERE ***
//                 // CHANGED USERNAME from 'ec2-user' to 'ubuntu' 
//                 // to match the Ubuntu 22.04 AMI (ami-0fb0b230890ccd1e6)
//                 bat "wsl ansible-playbook -i dynamic_inventory.ini grafana_playbook.yml -u ubuntu --private-key /home/adii_linux/.ssh/id_rsa"
//             }
//         }
//     }

//     post {
//         always {
//             // FIX APPLIED HERE: Removed the incorrect 'steps' block 
//             // to resolve the NoSuchMethodError in the Post Actions.
            
//             // Use 'bat' for file removal on Windows
//             bat 'del /f dynamic_inventory.ini'
//         }
//     }
// }

// pipeline {

//     agent any

//     environment {
//         // Terraform environment variables
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         // These variables are no longer needed for destroy, but kept for general context
//         SSH_CRED_ID = 'Aadii_id' 
//     }

//     stages {

//         stage('Terraform Destroy') {
//             steps {
//                 // Securely inject AWS credentials using the Jenkins 'AWS_Aadii' credential ID
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     script {
//                         echo "Starting Terraform destroy..."
                        
//                         // 1. Initialize Terraform
//                         bat 'terraform init'

//                         // 2. Execute Terraform destroy command
//                         // This removes all resources defined in your configuration
//                         bat 'terraform destroy -auto-approve'

//                         echo "Terraform destroy complete."
//                     }
//                 }
//             }
//         }
        
//         // The 'Wait for AWS Instance Status' and 'Ansible Configuration' stages are removed
//         // because the goal is now to destroy, not configure.
//     }

//     post {
//         always {
//             // Cleanup post-destroy, although the inventory file might not exist if 
//             // the destroy pipeline is run standalone.
//             bat 'del /f dynamic_inventory.ini'
//         }
//     }
// }
pipeline {
    agent any

    // Define consistent environment variables for Terraform
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS = '-no-color'
        // Credential ID for the SSH Key (used by the ansiblePlaybook step)
        SSH_CRED_ID = 'Aadii_id' // <-- Use your actual Jenkins SSH Credential ID
        AWS_REGION = 'us-east-2' // <-- The region for AWS CLI wait command
    }

    stages {
        // --- 1. Terraform Initialization (No credentials needed yet) ---
        stage('Terraform Initialization') {
            steps {
                // CORRECTED: Using 'bat' for Windows agent
                bat 'terraform init'
            }
        }

        // --- 2. Terraform Plan (Requires AWS Credentials) ---
        stage('Terraform Plan') {
            steps {
                // Securely inject AWS credentials for Terraform
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    // CORRECTED: Using 'bat' for Windows agent
                    bat 'terraform plan'
                }
            }
        }

        // --- 3. Manual Validation for Apply ---
        stage('Validate Apply') {
            input {
                message "Do you want to apply this plan and provision the infrastructure?"
                ok "Apply"
            }
            steps {
                echo 'Apply Accepted. Starting Provisioning...'
            }
        }

        // --- 4. Terraform Provisioning and Output Extraction ---
        stage('Terraform Provisioning') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        // Apply the infrastructure changes
                        // CORRECTED: Using 'bat' for Windows agent
                        bat 'terraform apply -auto-approve'

                        // Windows requires 'powershell' to reliably capture command output (returnStdout: true)
                        // 1. Extract Public IP Address
                        env.INSTANCE_IP = powershell(
                            script: 'terraform output -raw instance_public_ip',
                            returnStdout: true
                        ).trim()

                        // 2. Extract Instance ID
                        env.INSTANCE_ID = powershell(
                            script: 'terraform output -raw instance_id',
                            returnStdout: true
                        ).trim()

                        echo "Provisioned Instance IP: ${env.INSTANCE_IP}"
                        echo "Provisioned Instance ID: ${env.INSTANCE_ID}"

                        // 3. Create a dynamic inventory file for Ansible
                        // CORRECTED: Using 'bat' for Windows agent file creation
                        bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
                    }
                }
            }
        }

        // --- 5. Wait for AWS Health Checks (Requires AWS Credentials) ---
        stage('Wait for AWS Instance Status') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo "Waiting for instance ${env.INSTANCE_ID} to pass AWS health checks in region ${env.AWS_REGION}..."

                    // AWS CLI wait command
                    // CORRECTED: Using 'bat' for Windows agent
                    bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region ${env.AWS_REGION}"

                    echo 'AWS instance health checks passed. Proceeding to Ansible.'
                }
            }
        }

        // --- 6. Manual Validation for Ansible Configuration ---
        stage('Validate Ansible') {
            input {
                message "Do you want to run Ansible to configure the instance?"
                ok "Run Ansible"
            }
            steps {
                echo 'Ansible approved. Starting configuration...'
            }
        }

        // --- 7. Ansible Configuration (Requires SSH Credentials) ---
        stage('Ansible Configuration') {
            steps {
                // NOTE: The 'ansiblePlaybook' step is a Jenkins plugin step and is OS-agnostic, 
                // but the underlying execution might still need a shell. 
                // If this fails, you may need to revert to the BAT/WSL command in your original pipeline.
                ansiblePlaybook(
                    playbook: 'playbooks/grafana.yml',
                    inventory: 'dynamic_inventory.ini',
                    credentialsId: env.SSH_CRED_ID,
                    extras: "-u ubuntu" // Check your AMI's default user!
                )
            }
        }

        // --- 8. Manual Validation for Destroy ---
        stage('Validate Destroy') {
            input {
                message "Do you want to destroy the deployed infrastructure?"
                ok "Destroy"
            }
            steps {
                echo 'Destroy Approved. Starting teardown...'
            }
        }

        // --- 9. Terraform Destroy (Requires AWS Credentials) ---
        stage('Destroy') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    // CORRECTED: Using 'bat' for Windows agent
                    bat 'terraform destroy -auto-approve'
                }
            }
        }
    }

    // --- Post Actions (Cleanup and Failure Handling) ---
    post {
        always {
            echo 'Cleaning up dynamic_inventory.ini...'
            // CORRECTED: Using 'bat' for Windows file removal
            bat 'del /f dynamic_inventory.ini'
        }
        success {
            echo '✅ Pipeline execution successful!'
        }
        failure {
            echo '🚨 Pipeline failed. Attempting to destroy provisioned infrastructure...'
            withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                // CORRECTED: Using 'bat' for Windows agent
                bat 'terraform destroy -auto-approve'
            }
            echo 'Cleanup attempt complete.'
        }
    }
}