pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Ansible Install Apache & Deploy Web App') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i ../terraform/inventory.ini install_web.yml'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'curl http://<4.157.253.67>'
            }
        }
    }
}
