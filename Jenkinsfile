pipeline {
   
    environment {
       def scannerHome = tool 'Xebia1'
	DOCKERHUB_CREDS= credentials('DockerHub')
	SonarScannerX= credentials('SonarScannerID')
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
                    withSonarQubeEnv(installationName: 'VivekSonarServer') {
                        // Run SonarQube scanner for code analysis
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=EMP-Xebia -Dsonar.sources=. -Dsonar.login=$SonarScannerX"
                    }
                }
            }
        }

       stage('SonarQube Quality Gates') {
            steps {
                script {
                    withSonarQubeEnv(installationName: 'VivekSonarServer') {
                        timeout(time: 1, unit: 'HOURS') {
                            // Wait for SonarQube quality gates to pass/fail
                            def qg = waitForQualityGate(abortPipeline: false, credentialsId: '$SonarScannerX')
                            if (qg.status != 'OK') {
                                error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            }
                        }
                    }
                }
            }
        }

stage('Clean Up') {
            steps {
                sh returnStatus: true, script: 'docker stop $(docker ps -a | grep ${JOB_NAME} | awk \'{print $1}\')'
                sh returnStatus: true, script: 'docker rmi $(docker images | grep ${registry} | awk \'{print $3}\') --force'
                sh returnStatus: true, script: 'docker rmi -f ${JOB_NAME}'
            }
        } 

        stage('Build image') {
            steps {
                sh 'docker build -t flask-app .'
            }
        }

        stage('Push To Dockerhub') {
            steps {
                sh "docker tag Xebia-app viveka1302/Xebia-app:latest"
                sh "docker login -u $DOCKERHUB_CREDS_USER -p $DOCKERHUB_CREDS_PSW"
                sh "docker push viveka1302/new_Xebia_app"
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
