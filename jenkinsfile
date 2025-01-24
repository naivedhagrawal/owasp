@Library('Shared-Libraries') _
pipeline {
    agent {
        kubernetes {
            yaml docker()
        }
    }

    environment {
        SNYK_TOKEN = credentials('SNYK_TOKEN') // Fetch the credential with ID 'SNYK_TOKEN'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh """
                    docker build --build-arg SNYK_TOKEN=$SNYK_TOKEN -t snyk-image:latest .
                    """
                }
            }
        }

        stage('Push') {
            steps {
                container('docker') {
                    withCredentials([usernamePassword(credentialsId: 'docker_hub_up', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''
                        docker login -u $USERNAME -p $PASSWORD
                        docker tag snyk-image:latest naivedh/snyk-image:latest
                        docker push naivedh/snyk-image:latest
                        '''
                    }
                }
            }
        }
    }
}
