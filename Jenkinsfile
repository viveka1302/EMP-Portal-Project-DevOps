pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Shantanu-2001/EMP-Portal-Project-DevOps']]])
            }
        }
        stage('Build') {
            steps {
                git branch: 'main', url: 'https://github.com/Shantanu-2001/EMP-Portal-Project-DevOps'
                sh 'python3 app.py'
            }
        }
        stage('Test') {
            steps {
                sh 'python3 -m pytest'
            }
        }
    }
}
