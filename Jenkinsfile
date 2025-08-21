pipeline {
  agent { label 'win-host' }
  options { timestamps() }
  triggers { githubPush() }

  // Change default at runtime on "Build with Parameters"
  parameters {
    string(name: 'RUN_SECONDS', defaultValue: '3', description: 'Seconds to run the log-only stages before timing out (timeout is treated as SUCCESS).')
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Run matrix-screen.ps1 (log only, timed)') {
      steps {
        script {
          try {
            timeout(time: (params.RUN_SECONDS as Integer), unit: 'SECONDS') {
              powershell '''
                Set-ExecutionPolicy -Scope Process Bypass -Force
                $ErrorActionPreference = "Stop"

                # Non-interactive shim for Read-Host (Jenkins)
                if ($env:JENKINS_URL) {
                  Set-Item function:global:Read-Host {
                    param([string]$Prompt,[switch]$AsSecureString)
                    if ($AsSecureString) { return (ConvertTo-SecureString "" -AsPlainText -Force) }
                    return ""
                  }
                }

                Write-Host ">>> Running matrix-screen.ps1 (timed log run)"
                ./matrix-screen.ps1
              '''
            }
          } catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException e) {
            echo "matrix-screen.ps1 timed out after ${params.RUN_SECONDS}s — treating as SUCCESS"
            currentBuild.result = 'SUCCESS'
          }
        }
      }
    }

    stage('Run matrix-screen.ps1 (visible)') {
      steps {
        // Launches a separate, visible PowerShell window on your desktop
        bat '''
          start powershell -NoExit -Command "./matrix-screen.ps1"
        '''
      }
    }

    stage('Run matrix-screen-2.0.ps1 (log only, timed)') {
      steps {
        script {
          try {
            timeout(time: (params.RUN_SECONDS as Integer), unit: 'SECONDS') {
              powershell '''
                Set-ExecutionPolicy -Scope Process Bypass -Force
                $ErrorActionPreference = "Stop"

                # Non-interactive shim for Read-Host (Jenkins)
                if ($env:JENKINS_URL) {
                  Set-Item function:global:Read-Host {
                    param([string]$Prompt,[switch]$AsSecureString)
                    if ($AsSecureString) { return (ConvertTo-SecureString "" -AsPlainText -Force) }
                    return ""
                  }
                }

                Write-Host ">>> Running matrix-screen-2.0.ps1 (timed log run)"
                ./matrix-screen-2.0.ps1
              '''
            }
          } catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException e) {
            echo "matrix-screen-2.0.ps1 timed out after ${params.RUN_SECONDS}s — treating as SUCCESS"
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
      echo "Pipeline finished on Windows host. Timed log-only stages return SUCCESS on timeout; visible windows may still be running."
    }
  }
}
