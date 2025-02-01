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
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script {
                        dir('terraform-freeswitch') {  // Ensure this matches your Terraform directory
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true
                            
                            terraform init -input=false
                            
                            # Apply only dependencies (Terraform automatically loads all .tf files)
                            terraform apply -auto-approve -target=aws_eip.freeswitch
                            terraform apply -auto-approve -target=aws_security_group.voip_server
                            terraform apply -auto-approve -target=aws_key_pair.freeswitch
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
   