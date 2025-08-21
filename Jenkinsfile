pipeline {
  agent { label 'win-host' }
  options { timestamps() }
  triggers { githubPush() }

  stages {
    stage('Checkout') {
      steps {
        // Git must be installed on your Windows host and in PATH
        checkout scm
      }
    }
    stage('Run visible PowerShell') {
      steps {
        bat '''
          start powershell -NoExit -Command "./matrix-screen.ps1"
        '''
      }
    }
    stage('Run visible PowerShell') {
      steps {
        bat '''
          start powershell -NoExit -Command "./matrix-screen-2.0.ps1"
        '''
      }
    }
    stage('Run matrix-screen.ps1') {
      steps {
        // Use Windows PowerShell 5.1 by default
        // Timeout prevents long-running effects from an infinite loop script
        timeout(time: 10, unit: 'SECONDS') {
          powershell '''
            Write-Host "Running matrix-screen.ps1 on HOST..."
            .\\matrix-screen.ps1
          '''
        }
      }
    }

    stage('Run matrix-screen-2.0.ps1') {
      steps {
        timeout(time: 10, unit: 'SECONDS') {
          powershell '''
            Write-Host "Running matrix-screen-2.0.ps1 on HOST..."
            .\\matrix-screen-2.0.ps1
          '''
        }
      }
    }
  }

  post {
    always { echo "Done (executed on Windows host)." }
  }
}
