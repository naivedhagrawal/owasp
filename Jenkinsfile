@Library('k8s-shared-lib') _
pipeline {
    agent {
        kubernetes {
            yaml docker()
            showRawYaml false
        }
    }

    stages {
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh """
                    docker build -t owasp-dep:latest .
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
                        docker tag owasp-dep:latest naivedh/owasp-dep:latest
                        docker push naivedh/owasp-dep:latest
                        '''
                    }
                }
            }
        }
    }
}
