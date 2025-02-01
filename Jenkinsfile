pipeline {
    agent any

    stages {
        stage('Fetch Existing Terraform Outputs') {
            steps {
                script {
                    dir('terraform-freeswitch') {  
                        sh '''
                        # Initialize Terraform (ensures state file is available)
                        terraform init -input=false
                        
                        # Fetch Terraform outputs from the state file
                        terraform output -raw security_group_id > security_group_id.txt
                        terraform output -raw key_pair_name > key_pair_name.txt
                        terraform output -raw eip_allocation_id > eip_allocation_id.txt
                        '''
                    }
                }
            }
        }

        stage('Read Outputs and Set Environment Variables') {
            steps {
                script {
                    dir('terraform-freeswitch') {  
                        env.SECURITY_GROUP_ID = sh(script: 'cat security_group_id.txt', returnStdout: true).trim()
                        env.KEY_PAIR_NAME = sh(script: 'cat key_pair_name.txt', returnStdout: true).trim()
                        env.EIP_ALLOCATION_ID = sh(script: 'cat eip_allocation_id.txt', returnStdout: true).trim()

                        echo "Security Group ID: ${env.SECURITY_GROUP_ID}"
                        echo "Key Pair Name: ${env.KEY_PAIR_NAME}"
                        echo "EIP Allocation ID: ${env.EIP_ALLOCATION_ID}"
                    }
                }
            }
        }

        stage('Create EC2 Instance and Attach Dependencies') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'yytermi_aws',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    script {
                        dir('terraform-freeswitch') {  
                            sh """
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true

                            # Read variables from output files
                            SECURITY_GROUP_ID=\$(cat security_group_id.txt)
                            KEY_PAIR_NAME=\$(cat key_pair_name.txt)
                            EIP_ALLOCATION_ID=\$(cat eip_allocation_id.txt)

                            echo "Creating EC2 with Security Group: \$SECURITY_GROUP_ID, Key Pair: \$KEY_PAIR_NAME, EIP: \$EIP_ALLOCATION_ID"

                            # Apply Terraform with dynamically loaded variables
                            terraform apply -auto-approve \
                                -var="security_group_id=\$SECURITY_GROUP_ID" \
                                -var="key_pair_name=\$KEY_PAIR_NAME" \
                                -var="eip_allocation_id=\$EIP_ALLOCATION_ID"
                            """
                        }
                    }
                }
            }
        }
    }
}
