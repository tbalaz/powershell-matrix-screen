pipeline {
  agent { label 'win-host' }
  options { timestamps() }
  triggers { githubPush() }

  environment {
    // Change this to how long you want the log-only runs to last
    RUN_SECONDS = '10'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Run matrix-screen.ps1 (log only, timed)') {
      steps {
        timeout(time: env.RUN_SECONDS as Integer, unit: 'SECONDS') {
          powershell '''
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
            $ErrorActionPreference = "Stop"
            Write-Host ">>> Running matrix-screen.ps1 (Jenkins log only, timed)"
            ./matrix-screen.ps1
          '''
        }
      }
    }

    stage('Run matrix-screen.ps1 (visible)') {
      steps {
        // Pops a visible PowerShell window on your desktop; Jenkins does not wait for it to finish
        bat '''
          start powershell -NoExit -Command "./matrix-screen.ps1"
        '''
      }
    }

    stage('Run matrix-screen-2.0.ps1 (log only, timed)') {
      steps {
        timeout(time: env.RUN_SECONDS as Integer, unit: 'SECONDS') {
          powershell '''
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
            $ErrorActionPreference = "Stop"
            Write-Host ">>> Running matrix-screen-2.0.ps1 (Jenkins log only, timed)"
            ./matrix-screen-2.0.ps1
          '''
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
    always { echo "Done (executed on Windows host). Visible windows may still be running." }
  }
}
