
pipeline {
    agent any

    stages {
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Ansible Setup') {
            steps {
                sh 'ansible-playbook -i $(terraform -chdir=terraform output -raw public_ip_address), ansible/install_web.yml --user haseebadmin --private-key ~/.ssh/id_rsa'
            }
        }

        stage('Verification') {
            steps {
                sh 'curl $(terraform -chdir=terraform output -raw public_ip_address)'
            }
        }
    }
}
