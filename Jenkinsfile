pipeline {
    agent any

    environment {
        TF_VAR_security_group_id = ''
        TF_VAR_key_pair_name = ''
        TF_VAR_eip_allocation_id = ''
    }

    stages {
        stage('Apply Dependencies (SG, Key Pair, EIP)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'yytermi_aws', 
                                  accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script {
                        dir('terraform-freeswitch') {  
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true

                            terraform init -input=false

                            # Apply dependencies
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

        stage('Read Outputs and Set Environment Variables') {
            steps {
                script {
                    dir('terraform-freeswitch') {  
                        TF_VAR_security_group_id = sh(script: 'cat security_group_id.txt', returnStdout: true).trim()
                        TF_VAR_key_pair_name = sh(script: 'cat key_pair_name.txt', returnStdout: true).trim()
                        TF_VAR_eip_allocation_id = sh(script: 'cat eip_allocation_id.txt', returnStdout: true).trim()

                        echo "Security Group ID: ${TF_VAR_security_group_id}"
                        echo "Key Pair Name: ${TF_VAR_key_pair_name}"
                        echo "EIP Allocation ID: ${TF_VAR_eip_allocation_id}"
                    }
                }
            }
        }

        stage('Create EC2 Instance and Attach Dependencies') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'yytermi_aws', 
                                  accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script {
                        dir('terraform-freeswitch') {  
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true

                            # Run Terraform apply with dynamic values
                            terraform apply -auto-approve \
                                -var="security_group_id=${TF_VAR_security_group_id}" \
                                -var="key_pair_name=${TF_VAR_key_pair_name}" \
                                -var="eip_allocation_id=${TF_VAR_eip_allocation_id}"
                            '''
                        }
                    }
                }
            }
        }
    }
}
