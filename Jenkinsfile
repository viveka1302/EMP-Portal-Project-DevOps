pipeline {
  agent any

 

stages {
     stage('Checkout') {
            steps {
                git credentialsId: 'github-jenkins', url: 'https://github.com/Shantanu-2001/EMP-Portal-Project-DevOps.git'
                echo 'CheckOut Success'
            }
        }

 

stage('lint'){
   steps {
        sh "virtualenv --python=/usr/bin/python venv"
        sh "export TERM='linux'"  
        sh 'pylint --rcfile=pylint.cfg funniest/ $(find . -maxdepth 1 -name "*.py" -print) --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" > pylint.log || echo "pylint exited with $?"'
        sh "rm -r venv/"

        echo "linting Success, Generating Report"

        warnings canComputeNew: false, canResolveRelativePaths: false, defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', messagesPattern: '', parserConfigurations: [[parserName: 'PyLint', pattern: '*']], unHealthy: ''

       }   
     }

stage('test'){
   steps {

        sh "pytest --cov ./ --cov-report html --verbose"
        publishHTML(target:
            [allowMissing: false,
              alwaysLinkToLastBuild: false,
            keepAll: false,
            reportDir: 'htmlcov',
            reportFiles: 'index.html',
            reportName: 'Test Report',
            reportTitles: ''])  

        echo "Testing Success"   
          }  
        }

   

 

       }
}
