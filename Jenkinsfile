pipeline {
    agent any
    
    stages {
        stage('Pull Repository') {
            steps {
		checkout scmGit(branches: [[name: '*/Dev']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/viveka1302/EMP-Portal-Project-DevOps.git']])
            }
        }
        
        stage('Build and Test') {
            steps {
		sh 'sudo su'

                sh 'pip install -r requirements.txt' // Install project dependencies
                
                sh 'pylint app.py' // Run pylint for code analysis
                
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
	stage('SonarQube Analysis') {
   	 def scannerHome = tool 'VivekSonarServer';
  	  withSonarQubeEnv() {
		steps{
  	 	   sh "${scannerHome}/bin/sonar-scanner"
   	      		}
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
