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
// pipeline {
//     agent any

//     environment {
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         AWS_REGION = 'us-east-1' 
//     }

//     stages {
//         stage('Terraform Initialization') {
//             steps {
//                 // Wrap this in credentials so terraform can talk to AWS to generate the plan
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     bat 'terraform init'
//                     bat 'terraform plan'
//                 }
//             }
//         }

//         stage('Approve Infrastructure') {
//             steps {
//                 input message: "Review the plan in the logs. Do you want to provision the AWS resources?", ok: "Yes, Deploy"
//             }
//         }

//         stage('Terraform Provisioning') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     script {
//                         bat 'terraform apply -auto-approve'
                        
//                         // Extract IP and ID using PowerShell to ensure clean strings
//                         env.INSTANCE_IP = powershell(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
//                         env.INSTANCE_ID = powershell(script: 'terraform output -raw instance_id', returnStdout: true).trim()
                        
//                         echo "Provisioned Instance IP: ${env.INSTANCE_IP}"
//                         bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
//                     }
//                 }
//             }
//         }

//         stage('Wait for AWS Instance Status') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     echo "Waiting for instance ${env.INSTANCE_ID} to pass health checks..."
//                     bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region ${env.AWS_REGION}"
//                 }
//             }
//         }

//         stage('Approve Ansible') {
//             steps {
//                 input message: "Instance is healthy. Run Ansible playbook?", ok: "Run Ansible"
//             }
//         }

//         stage('Ansible Configuration') {
//             steps {
//                 echo "Running Ansible using WSL internal SSH key..."
//                 // Ensure your playbook path is correct (playbooks/grafana.yml vs grafana_playbook.yml)
//                 bat "wsl ansible-playbook -i dynamic_inventory.ini grafana_playbook.yml -u ubuntu --private-key /home/adii_linux/.ssh/id_rsa"
//             }
//         }

//         stage('Manual Destroy') {
//             steps {
//                 input message: "Finished testing Grafana? Click to destroy infrastructure.", ok: "Destroy Now"
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     bat 'terraform destroy -auto-approve'
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             bat 'if exist dynamic_inventory.ini del /f dynamic_inventory.ini'
//         }
//         success {
//             echo "✅ Deployment Complete!"
//         }
//         failure {
//             echo "🚨 Pipeline failed. Check the logs above."
//         }
//     }
// }

// pipeline {
//     agent any

//     environment {
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         SSH_CRED_ID = 'aws-deployer-ssh-key' 
//         TF_CLI_CONFIG_FILE = credentials('aws-creds')
//     }

//     stages {
//         stage('Terraform Initialization') {
//             steps {
//                 sh 'terraform init'
//                 sh 'cat $BRANCH_NAME.tfvars'
//             }
//         }
//         stage('Terraform Plan') {
//             steps {
//                 sh 'terraform plan -var-file=$BRANCH_NAME.tfvars'
//             }
//         }
//         stage('Validate Apply') {
            
//             input {
//                 message "Do you want to apply this plan?"
//                 ok "Apply"
//             }
//             steps {
//                 echo 'Apply Accepted'
//             }
//         }
//         stage('Terraform Provisioning') {
//             steps {
//                 script {
//                     sh 'terraform apply -auto-approve -var-file=$BRANCH_NAME.tfvars'

//                     // 1. Extract Public IP Address of the provisioned instance
//                     env.INSTANCE_IP = sh(
//                         script: 'terraform output -raw instance_public_ip', 
//                         returnStdout: true
//                     ).trim()
                    
//                     // 2. Extract Instance ID (for AWS CLI wait) 
//                     env.INSTANCE_ID = sh(
//                         script: 'terraform output -raw instance_id', 
//                         returnStdout: true
//                     ).trim()

//                     echo "Provisioned Instance IP: ${env.INSTANCE_IP}"
//                     echo "Provisioned Instance ID: ${env.INSTANCE_ID}"
                    
//                     // 3. Create a dynamic inventory file for Ansible 
//                     sh "echo '${env.INSTANCE_IP}' > dynamic_inventory.ini"
//                 }
//             }
//         }

//         stage('Wait for AWS Instance Status') {
//             steps {
//                 echo "Waiting for instance ${env.INSTANCE_ID} to pass AWS health checks..."
                
//                 // --- This is the simple, powerful AWS CLI command ---
//                 // It polls AWS until status checks pass or it hits the default timeout (usually 15 minutes)
//                 sh "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-2"  
                
//                 echo 'AWS instance health checks passed. Proceeding to Ansible.'
//             }
//         }
//         stage('Validate Ansible') {
            
//             input {
//                 message "Do you want to run Ansible?"
//                 ok "Run Ansible"
//             }
//             steps {
//                 echo 'Ansible approved'
//             }
//         }
//         stage('Ansible Configuration') {
//             steps {
//                 // Now you can proceed directly to Ansible, knowing SSH is almost certainly ready.
//                 ansiblePlaybook(
//                     playbook: 'playbooks/grafana.yml',
//                     inventory: 'dynamic_inventory.ini', 
//                     credentialsId: SSH_CRED_ID, // Key is securely injected by the plugin here
//                 )
//             }
//         }
//         stage('Validate Destroy') {
//             input {
//                 message "Do you want to destroy??"
//                 ok "Destroy"
//             }
//             steps {
//                 echo 'Destroy Approved'
//             }
//         }
//         stage('Destroy') {
//             steps {
//                 sh 'terraform destroy -auto-approve -var-file=$BRANCH_NAME.tfvars'
//             }
//         }
//     }    
//     post {
//         always {
//             sh 'rm -f dynamic_inventory.ini'
//         }
//         success {
//             echo 'Success!'
//         }
//         failure {
//             sh 'terraform destroy -auto-approve -var-file=$BRANCH_NAME.tfvars || echo "Cleanup failed, please check manually."'
//         }
//     }
// }


// pipeline {
//     agent any

//     environment {
//         TF_IN_AUTOMATION = 'true'
//         TF_CLI_ARGS = '-no-color'
//         AWS_REGION = 'us-east-1' 
//         WSL_SSH_KEY = '/home/adii_linux/.ssh/id_rsa'
//     }

//     stages {
//         stage('Setup Environment') {
//             steps {
//                 script {
//                     // 1. Detect branch name dynamically
//                     def branch = env.GIT_BRANCH ?: env.BRANCH_NAME ?: bat(script: "@git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    
//                     if (!branch || branch == "HEAD") {
//                         error "Could not determine branch name. Ensure you are running from a Git repository."
//                     }

//                     // 2. Clean the string (e.g., 'origin/main' -> 'main')
//                     env.CLEAN_BRANCH = branch.contains('/') ? branch.split('/')[-1] : branch
                    
//                     echo "Successfully detected branch: ${env.CLEAN_BRANCH}"
                    
//                     // 3. Verify that the required .tfvars file exists
//                     def tfvarsFile = "${env.CLEAN_BRANCH}.tfvars"
//                     def fileExists = bat(script: "@if exist ${tfvarsFile} (echo true) else (echo false)", returnStdout: true).trim()
                    
//                     if (fileExists == "false") {
//                         error "ABORTING: No variable file found for this branch. Please create ${tfvarsFile} in your repository."
//                     }
//                 }
//             }
//         }

//         stage('Terraform Initialization') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     bat 'terraform init'
//                     bat "terraform plan -var-file=${env.CLEAN_BRANCH}.tfvars"
//                 }
//             }
//         }

//         stage('Validate Apply') {
//             input {
//                 message "Do you want to apply the plan for ${env.CLEAN_BRANCH}?"
//                 ok "Apply"
//             }
//             steps {
//                 echo "Apply Accepted for branch ${env.CLEAN_BRANCH}"
//             }
//         }

//         stage('Terraform Provisioning') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     script {
//                         bat "terraform apply -auto-approve -var-file=${env.CLEAN_BRANCH}.tfvars"

//                         // Extract outputs using PowerShell
//                         env.INSTANCE_IP = powershell(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
//                         env.INSTANCE_ID = powershell(script: 'terraform output -raw instance_id', returnStdout: true).trim()

//                         echo "Provisioned IP: ${env.INSTANCE_IP}"
//                         bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
//                     }
//                 }
//             }
//         }

//         stage('Wait for AWS Instance Status') {
//             steps {
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     echo "Waiting for instance ${env.INSTANCE_ID} to pass health checks..."
//                     bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region ${env.AWS_REGION}"
//                 }
//             }
//         }

//         stage('Validate Ansible') {
//             input {
//                 message "Provisioning complete. Run Ansible playbook?"
//                 ok "Run Ansible"
//             }
//             steps {
//                 echo 'Ansible execution approved'
//             }
//         }

//         stage('Ansible Configuration') {
//             steps {
//                 echo "Running Ansible via WSL Bridge..."
//                 bat "wsl ansible-playbook -i dynamic_inventory.ini grafana_playbook.yml -u ubuntu --private-key ${env.WSL_SSH_KEY}"
//             }
//         }

//         stage('Manual Destroy') {
//             steps {
//                 input message: "Testing finished. Destroy infrastructure for ${env.CLEAN_BRANCH}?", ok: "Destroy Now"
//                 withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                     bat "terraform destroy -auto-approve -var-file=${env.CLEAN_BRANCH}.tfvars"
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             bat 'if exist dynamic_inventory.ini del /f dynamic_inventory.ini'
//         }
//         success {
//             echo "✅ Deployment on branch '${env.CLEAN_BRANCH}' completed successfully!"
//         }
//         failure {
//             script {
//                 if (env.CLEAN_BRANCH) {
//                     withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                         echo "🚨 Pipeline failed. Attempting automated cleanup for ${env.CLEAN_BRANCH}..."
//                         bat "terraform destroy -auto-approve -var-file=${env.CLEAN_BRANCH}.tfvars || echo 'Manual cleanup required'"
//                     }
//                 }
//             }
//         }
//     }
// }
pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS = '-no-color'
        AWS_REGION = 'us-east-1' 
        WSL_SSH_KEY = '/home/adii_linux/.ssh/id_rsa'
    }

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Detect branch name dynamically from Jenkins env or Git CLI
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME ?: bat(script: "@git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    
                    if (!branch || branch == "HEAD") {
                        error "Could not determine branch name. Ensure you are running from a Git repository."
                    }

                    // Clean the string (e.g., 'origin/dev' -> 'dev')
                    env.CLEAN_BRANCH = branch.contains('/') ? branch.split('/')[-1] : branch
                    echo "Successfully detected branch: ${env.CLEAN_BRANCH}"
                    
                    // Verify that the required .tfvars file exists before proceeding
                    def tfvarsFile = "${env.CLEAN_BRANCH}.tfvars"
                    def fileExists = bat(script: "@if exist ${tfvarsFile} (echo true) else (echo false)", returnStdout: true).trim()
                    
                    if (fileExists == "false") {
                        error "ABORTING: No variable file found for this branch. Please create ${tfvarsFile} in your repository."
                    }

                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME ?: bat(script: "@git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    env.CLEAN_BRANCH = branch.contains('/') ? branch.split('/')[-1] : branch
                    echo "Branch: ${env.CLEAN_BRANCH}"
                }
            }
        }

        stage('Terraform Initialization') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat 'terraform init'
                    bat "terraform plan -var-file=${env.CLEAN_BRANCH}.tfvars"
                }
            }
        }

        stage('Validate Apply') {

            input {
                message "Do you want to apply the plan for ${env.CLEAN_BRANCH}?"
                ok "Apply"
            }
            steps {
                echo "Apply Accepted for branch ${env.CLEAN_BRANCH}"

            steps {
                script {
                    // Only ask if NOT on main branch
                    if (env.CLEAN_BRANCH != 'main') {
                        input message: "Do you want to apply the plan for ${env.CLEAN_BRANCH}?", ok: "Apply"
                    }
                }
            }
        }

        stage('Terraform Provisioning') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        bat "terraform apply -auto-approve -var-file=${env.CLEAN_BRANCH}.tfvars"


                        // Extract outputs using PowerShell to avoid Windows CLI "noisse"
                        env.INSTANCE_IP = powershell(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                        env.INSTANCE_ID = powershell(script: 'terraform output -raw instance_id', returnStdout: true).trim()

                        echo "Provisioned IP: ${env.INSTANCE_IP}"

                        env.INSTANCE_IP = powershell(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                        env.INSTANCE_ID = powershell(script: 'terraform output -raw instance_id', returnStdout: true).trim()

                        bat "echo ${env.INSTANCE_IP} > dynamic_inventory.ini"
                    }
                }
            }
        }

        stage('Wait for AWS Instance Status') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region ${env.AWS_REGION}"
                }
            }
        }

        stage('Validate Ansible') {
            steps {
                script {
                    // Only ask if NOT on main branch
                    if (env.CLEAN_BRANCH != 'main') {
                        input message: "Run Ansible playbook?", ok: "Run Ansible"
                    }
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
 
                echo "Running Ansible via WSL Bridge..."

                bat "wsl ansible-playbook -i dynamic_inventory.ini grafana_playbook.yml -u ubuntu --private-key ${env.WSL_SSH_KEY}"
            }
        }

        stage('Manual Destroy') {
            steps {

                input message: "Testing finished. Destroy infrastructure for ${env.CLEAN_BRANCH}?", ok: "Destroy Now"

                // This input is OUTSIDE any if-statement, so it will ask for BOTH main and dev
                input message: "Testing finished. Destroy infrastructure for ${env.CLEAN_BRANCH}?", ok: "Destroy Now"
                

                withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat "terraform destroy -auto-approve -var-file=${env.CLEAN_BRANCH}.tfvars"
                }
            }
        }
    }

    post {
        always {
            bat 'if exist dynamic_inventory.ini del /f dynamic_inventory.ini'
        }

        success {
            echo "✅ Deployment on branch '${env.CLEAN_BRANCH}' completed successfully!"
        }
        failure {
            script {
                if (env.CLEAN_BRANCH) {
                    withCredentials([aws(credentialsId: 'AWS_Aadii', accesskeyVariable: 'AWS_ACCESS_KEY_ID', secretkeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        echo "🚨 Pipeline failed. Attempting automated cleanup for ${env.CLEAN_BRANCH}..."
                        bat "terraform destroy -auto-approve -var-file=${env.CLEAN_BRANCH}.tfvars || echo 'Manual cleanup required'"
                    }
                }
            }
        }

    }
}