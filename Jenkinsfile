pipeline {
  agent { label 'win-host' }
  options { timestamps() }
  triggers { githubPush() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Run matrix-screen.ps1') {
      steps {
        // capture status instead of failing the build immediately
        script {
          def rc = powershell(returnStatus: true, script: '''
            # Make sure policy doesn't block scripts in CI
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

            # Fail fast on errors so we can see where it breaks
            $ErrorActionPreference = "Stop"

            Write-Host ">>> Running matrix-screen.ps1"
            try {
              # run it; if it loops forever, add -TimeoutSeconds logic inside the script
              .\\matrix-screen.ps1
              Write-Host "matrix-screen.ps1 finished"
              exit 0
            }
            catch {
              Write-Host "ERROR in matrix-screen.ps1:"
              Write-Host ($_ | Format-List * -Force | Out-String)
              # Return 1 so Jenkins knows it failed
              exit 1
            }
          ''')
          echo "matrix-screen.ps1 exit code: ${rc}"
          if (rc != 0) {
            error("matrix-screen.ps1 failed with exit code ${rc}")
          }
        }
      }
    }

    stage('Run matrix-screen-2.0.ps1') {
      steps {
        script {
          def rc = powershell(returnStatus: true, script: '''
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
            $ErrorActionPreference = "Stop"

            Write-Host ">>> Running matrix-screen-2.0.ps1"
            try {
              .\\matrix-screen-2.0.ps1
              Write-Host "matrix-screen-2.0.ps1 finished"
              exit 0
            }
            catch {
              Write-Host "ERROR in matrix-screen-2.0.ps1:"
              Write-Host ($_ | Format-List * -Force | Out-String)
              exit 1
            }
          ''')
          echo "matrix-screen-2.0.ps1 exit code: ${rc}"
          if (rc != 0) {
            error("matrix-screen-2.0.ps1 failed with exit code ${rc}")
          }
        }
      }
    }
  }
  post {
    always { echo "Done (ran on Windows host)." }
  }
}
