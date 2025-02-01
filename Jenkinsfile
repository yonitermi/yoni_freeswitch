pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"  // Set AWS region
    }

    stages {
        stage('Apply Dependencies (SG, Key Pair, EIP)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'yytermi_aws', 
                                  accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script {
                        dir('terraform-freeswitch') {  // Explicitly set Terraform directory
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true
                            
                            terraform init -input=false
                            
                            # Apply only the dependencies
                            terraform apply -target=aws_security_group.freeswitch_sg \
                                            -target=aws_key_pair.freeswitch_key \
                                            -target=aws_eip.freeswitch_eip \
                                            -auto-approve
                            '''
                        }
                    }
                }
            }
        }

        stage('Apply Instance with Dependencies') {
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
                            
                            # Apply the instance after dependencies are created
                            terraform apply -target=aws_instance.freeswitch \
                                            -target=aws_eip_association.eip_assoc \
                                            -var "security_group_id=$(terraform output -raw security_group_id)" \
                                            -var "key_name=$(terraform output -raw key_name)" \
                                            -var "eip_id=$(terraform output -raw eip_id)" \
                                            -auto-approve
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
