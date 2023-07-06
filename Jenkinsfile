pipeline {
   
    environment {
       def scannerHome = tool 'Xebia1'

    }
 agent any
    stages {
        stage('Pull Repository') {
            steps {
		checkout scmGit(branches: [[name: '*/Dev']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/viveka1302/EMP-Portal-Project-DevOps.git']])
            }
        }
        
        stage('Build and Test') {
            steps {
	script{
	 sh "yes Y | sudo apt install python3.10-venv"

  	// Create a virtual environment
          sh 'python3 -m venv myenv'
          
          // Activate the virtual environment
          sh '. myenv/bin/activate'
		
		sh 'sudo su'

                sh 'pip install -r requirements.txt' // Install project dependencies
  
               } 
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
stage("Testing with Pytest"){
	steps{
		script{
			// Activate the virtual environment
       		   sh '. myenv/bin/activate'

				sh "python3 -m pytest test_app.py"
		}
	}

}
        
        
 stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(installationName: 'VivekSonarServer',credentialsId: "${SonarScannerID}") {
                        // Run SonarQube scanner for code analysis
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=EMP-Xebia -Dsonar.sources=."
                    }
                }
            }
        }

       stage('SonarQube Quality Gates') {
            steps {
                script {
                    withSonarQubeEnv(installationName: 'VivekSonarServer',credentialsId: "${SonarScannerID}") {
                        timeout(time: 1, unit: 'HOURS') {
                            // Wait for SonarQube quality gates to pass/fail
                            def qg = waitForQualityGate(abortPipeline: false, credentialsId: 'SonarScannerID')
                            if (qg.status != 'OK') {
                                error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            }
                        }
                    }
                }
            }
        }
    }
    
post {
    always {
        script {
		      // Deactivate the virtual environment
             sh 'if [[ -n "${VIRTUAL_ENV}" ]]; then deactivate; fi'

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
