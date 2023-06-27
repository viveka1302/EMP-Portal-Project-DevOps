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
                    
                    // Print the pylint log output
                    sh 'cat pylint.log'
                    
                    // Check the result and mark the stage as successful regardless
                    if (pylintResult == 0) {
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
                withSonarQubeEnv('SonarQube') {
                    // Run SonarQube analysis
                    // Replace with your project key and token
                    sh 'sonar-scanner -Dsonar.projectKey=EMP-Xebia -Dsonar.sources=new File('.').absolutePath -Dsonar.python.coverage.reportPaths=coverage.xml -Dsonar.login=sqp_659256cc488ba8aad71aea302d1d134c7e87a8ff'
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
                tokenCredentialId: 'slackcred'
            )
        }
    }
}
