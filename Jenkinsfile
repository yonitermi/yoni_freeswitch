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
                        dir('terraform-freeswitch') {  // Change to the correct directory
                            sh '''
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            export TF_IN_AUTOMATION=true
                            
                            terraform init -input=false
                            
                            # Apply each dependency separately
                            terraform apply -auto-approve eip_freeswitch.tf
                            terraform apply -auto-approve security_group.tf
                            terraform apply -auto-approve ssh_key.tf
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
