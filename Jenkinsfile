pipeline {
  agent { label 'win-host' }
  options { timestamps() }
  triggers { githubPush() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Run matrix-screen.ps1 (log only)') {
      steps {
        powershell '''
          Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
          Write-Host ">>> Running matrix-screen.ps1 (Jenkins log only)"
          ./matrix-screen.ps1
        '''
      }
    }

    stage('Run matrix-screen.ps1 (visible)') {
      steps {
        bat '''
          start powershell -NoExit -Command "./matrix-screen.ps1"
        '''
      }
    }

    stage('Run matrix-screen-2.0.ps1 (log only)') {
      steps {
        powershell '''
          Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
          Write-Host ">>> Running matrix-screen-2.0.ps1 (Jenkins log only)"
          ./matrix-screen-2.0.ps1
        '''
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
    always { echo "Done (executed on Windows host)." }
  }
}
