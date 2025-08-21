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
            Set-ExecutionPolicy -Scope Process Bypass -Force
            $ErrorActionPreference = "Stop"

            # In Jenkins (non-interactive), replace Read-Host with a no-op that returns ""
            if ($env:JENKINS_URL) {
              Set-Item function:global:Read-Host {
                param([string]$Prompt,[switch]$AsSecureString)
                if ($AsSecureString) { return (ConvertTo-SecureString "" -AsPlainText -Force) }
                return ""
              }
            }

            Write-Host ">>> Running matrix-screen.ps1 (timed, non-interactive shim)"
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

stage('Run matrix-screen-2.0.ps1 (log only, timed)') {
  steps {
    script {
      try {
        timeout(time: env.RUN_SECONDS as Integer, unit: 'SECONDS') {
          powershell '''
            Set-ExecutionPolicy -Scope Process Bypass -Force
            $ErrorActionPreference = "Stop"

            # Non-interactive shim for Read-Host
            if ($env:JENKINS_URL) {
              Set-Item function:global:Read-Host {
                param([string]$Prompt,[switch]$AsSecureString)
                if ($AsSecureString) { return (ConvertTo-SecureString "" -AsPlainText -Force) }
                return ""
              }
            }

            Write-Host ">>> Running matrix-screen-2.0.ps1 (timed, non-interactive shim)"
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


  post {
    always {
      echo "Pipeline finished. Timed stages exit with 0 if they only hit the timeout."
    }
  }
}
