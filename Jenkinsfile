pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"  // AWS Region
    }

    stages {
        stage('Apply Dependencies (SG, Key Pair, EIP)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                credentialsId: 'yytermi_aws', 
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]]) {
                    script {
                        dir('terraform-freeswitch') {  
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true
                            
                            terraform init -input=false
                            
                            # Apply dependencies (Security Group, Key Pair, Elastic IP)
                            terraform apply -auto-approve -target=aws_eip.freeswitch
                            terraform apply -auto-approve -target=aws_security_group.voip_server
                            terraform apply -auto-approve -target=aws_key_pair.freeswitch

                            # Capture Terraform outputs
                            terraform output -raw security_group_id > security_group_id.txt
                            terraform output -raw key_pair_name > key_pair_name.txt
                            terraform output -raw eip_allocation_id > eip_allocation_id.txt
                            '''
                        }
                    }
                }
            }
        }

        stage('Create EC2 Instance and Attach Dependencies') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                credentialsId: 'yytermi_aws', 
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]]) {
                    script {
                        dir('terraform-freeswitch') {  
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true
                            
                            # Read Terraform outputs dynamically
                            SECURITY_GROUP_ID=$(cat security_group_id.txt)
                            KEY_PAIR_NAME=$(cat key_pair_name.txt)
                            EIP_ALLOCATION_ID=$(cat eip_allocation_id.txt)

                            echo "Using Security Group: $SECURITY_GROUP_ID"
                            echo "Using Key Pair: $KEY_PAIR_NAME"
                            echo "Using EIP Allocation: $EIP_ALLOCATION_ID"

                            # Run Terraform apply with dynamic values
                            terraform apply -auto-approve -var="security_group_id=$SECURITY_GROUP_ID" \
                                                            -var="key_pair_name=$KEY_PAIR_NAME" \
                                                            -var="eip_allocation_id=$EIP_ALLOCATION_ID"
                            '''
                        }
                    }
                }
            }
        }
    }



    post {
        always {
            archiveArtifacts artifacts: '**/*.tf', fingerprint: true
        }
    }
}
   