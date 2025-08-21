pipeline {
  agent { label 'win-host' }
  options { timestamps() }
  triggers { githubPush() }

  environment {
    RUN_SECONDS = '10'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Run matrix-screen.ps1 (log only, timed)') {
      steps {
        script {
          try {
            timeout(time: env.RUN_SECONDS as Integer, unit: 'SECONDS') {
              powershell '''
                Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
                $ErrorActionPreference = "Stop"
                Write-Host ">>> Running matrix-screen.ps1 (timed log run)"
                ./matrix-screen.ps1
              '''
            }
          } catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException e) {
            echo "matrix-screen.ps1 timed out after ${env.RUN_SECONDS}s — treating as success"
            currentBuild.result = 'SUCCESS'
          }
        }
      }
    }

    stage('Run matrix-screen.ps1 (visible)') {
      steps {
        bat '''
          start powershell -NoExit -Command "./matrix-screen.ps1"
        '''
      }
    }

    stage('Run matrix-screen-2.0.ps1 (log only, timed)') {
      steps {
        script {
          try {
            timeout(time: env.RUN_SECONDS as Integer, unit: 'SECONDS') {
              powershell '''
                Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
                $ErrorActionPreference = "Stop"
                Write-Host ">>> Running matrix-screen-2.0.ps1 (timed log run)"
                ./matrix-screen-2.0.ps1
              '''
            }
          } catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException e) {
            echo "matrix-screen-2.0.ps1 timed out after ${env.RUN_SECONDS}s — treating as success"
            currentBuild.result = 'SUCCESS'
          }
        }
      }
    }

    stage('Run matrix-screen-2.0.ps1 (visible)') {
      steps {
        bat '''
          start powershell -NoExit -Command "./matrix-screen-2.0.ps1"
        '''
      }
    }
  }

  post {
    always {
      echo "Pipeline finished. Timed stages exit with 0 if they only hit the timeout."
    }
  }
}
