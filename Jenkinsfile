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
                    withCredentials([string(credentialsId: 'NVD_API_KEY', variable: 'NVD_API_KEY')]) {
                        sh """
                        docker build --build-arg NVD_API_KEY=$NVD_API_KEY -t owasp-dep:latest .
                        """
                    }
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
