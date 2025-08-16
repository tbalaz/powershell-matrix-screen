pipeline {
  agent any
  options { timestamps() }
  triggers { githubPush() } // harmless + useful
  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'ls -la' // prove we got your repo
      }
    }
    stage('Run PowerShell (5s demo)') {
      steps {
        script {
          // Run the Matrix script but cap it at 5s so the job doesn't hang
          catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS') {
            timeout(time: 5, unit: 'SECONDS') {
              pwsh(label: 'Matrix', script: './matrix-screen.ps1')
            }
          }
        }
      }
    }
  }
}
