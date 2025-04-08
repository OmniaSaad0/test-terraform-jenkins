pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Terraform') {
            steps {
                script {
                    sh '''
                    if ! command -v terraform &> /dev/null
                    then
                        echo "Terraform not found, installing..."
                        apt-get install wget unzip -y
                        wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
                        unzip terraform_1.7.5_linux_amd64.zip
                        mv terraform /usr/local/bin/
                    else
                        echo "Terraform already installed"
                    fi
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
               slackSend color: "good" , message: "AWS provisioning with Terraform was successful!"
        }
        failure {
               slackSend color: "good" , message: "AWS provisioning with Terraform failed."
        }
    }
}
