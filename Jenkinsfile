pipeline {
    agent any

    environment {
        TF_DIR = 'terraform'
        ANSIBLE_DIR = 'ansible'
        APP_DIR = 'app'
    }

    stages {
        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Public IP') {
            steps {
                script {
                    def ip = sh(script: "terraform -chdir=terraform output -raw public_ip_address", returnStdout: true).trim()
                    env.VM_IP = ip
                }
            }
        }

        stage('Ansible Install Web') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sh """
                      ansible-playbook install_web.yml \
                      -i '${VM_IP},' \
                      --private-key ~/.ssh/id_rsa \
                      -u azureuser
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'sleep 10'
                sh "curl http://${VM_IP}"
            }
        }
    }
}
