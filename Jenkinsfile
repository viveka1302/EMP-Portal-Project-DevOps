pipeline {
    agent any
    
    stages {
        stage('Pull Repository') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/Dev/*']],
                    userRemoteConfigs: [[url: 'https://github.com/viveka1302/EMP-Portal-Project-DevOps.git']]])
            }
        }
        
        stage('Build and Test') {
            steps {
                sh 'pip install -r requirements.txt' // Install project dependencies
                
                sh 'pylint your_module.py' // Run pylint for code analysis
                
                sh 'pytest' // Run unit tests with pytest
              /*  
                script {
                    // Start Flask server for testing
                    sh 'python app.py &'
                    sleep 10 // Wait for the server to start (adjust as needed)
                    
                    try {
                        sh 'pytest --cov=your_module_name' // Run integration tests with code coverage
                    } finally {
                        // Stop Flask server after testing
                        sh 'pkill -f "python app.py"'
                    }
                }*/
            }
        }
        
        stage('Merge to Main Branch') {
            when {
                not {
                    branch 'main/*'
                }
            }
            steps {
                sh 'git checkout main'
                sh 'git merge ${env.Dev}'
                sh 'git push origin main'
            }
        }
    }
    
    post {
        success {
            script {
                // Send notification for successful build
                notify("Build Successful", "The build and tests passed successfully.")
            }
        }
        failure {
            script {
                // Send notification for build failure
                notify("Build Failed", "The build or tests failed. Please check the Jenkins logs for details.")
            }
        }
    }
}

def notify(subject, message) {
    emailext (
        subject: subject,
        body: message,
        to: '500082607@stu.upes.ac.in',
    )
}
