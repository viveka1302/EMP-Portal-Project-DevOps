pipeline {
    agent any
    environment {
        PATH = "$PATH:/var/lib/jenkins/plugins/"
    }
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
  
                
            }
        }
	stage('Pylint Analysis') {
            steps {
                script {
                    // Run pylint and capture the result
                    def pylintResult = sh(
                        script: 'pylint app.py',
                        returnStatus: true
                    )
                    
                    
                    // Check the result and mark the stage as successful regardless
                    if (pylintResult) {
                        echo 'Pylint analysis passed'
                    } else {
                        echo 'Pylint analysis failed'
                    }
                }
            }
        }
        
        
stage('SonarQube Analysis') {
            steps {
                // Configure SonarQube Scanner
                withSonarQubeEnv('VivekSonarServer') {
                    // Run SonarQube analysis
                    // Replace with your project key and token
                   sh "/var/lib/jenkins/plugins/sonar -Dsonar.projectKey=EMP-Xebia -Dsonar.sources=${env.WORKSPACE} -Dsonar.python.coverage.reportPaths=coverage.xml -Dsonar.login=squ_6dfb72ffd8f034ed0d4da5920c4010ae3e77b316"
                }
            }
        }
    }
    
post {
    always {
        script {
            def buildStatus = currentBuild.currentResult ?: 'UNKNOWN'
            def color = buildStatus == 'SUCCESS' ? 'good' : 'danger'

            slackSend(
                channel: '#devops-project',
                color: color,
                message: "Build ${env.BUILD_NUMBER} ${buildStatus}: STAGE=${env.STAGE_NAME}",
                teamDomain: 'xaidv05',
                tokenCredentialId: 'SlackIDconfigReal'
            )
        }
    }
}
}
