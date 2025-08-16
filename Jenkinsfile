pipeline {
  agent any
  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '30'))
    disableConcurrentBuilds()
  }
  triggers { githubPush() }

  parameters {
    choice(name: 'SCRIPT', choices: ['matrix-screen.ps1', 'matrix-screen-2.0.ps1'], description: 'Which script to run')
    string(name: 'SECONDS', defaultValue: '8', description: 'How long to run (seconds)')
    booleanParam(name: 'RUN_LINT', defaultValue: false, description: 'Run PowerShell lint (PSScriptAnalyzer)')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'ls -la'
      }
    }

    stage('Sanity') {
      steps {
        sh 'git --version || true'
        sh 'pwsh --version || true'
      }
    }

    stage('Lint (optional)') {
      when { expression { return params.RUN_LINT } }
      steps {
        pwsh(label: 'PSScriptAnalyzer', script: '''
          Set-PSRepository PSGallery -InstallationPolicy Trusted
          if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
            Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
          }
          $violations = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error
          $violations | Out-File -FilePath pssa.txt -Force
          if ($violations) { throw "PSScriptAnalyzer found $($violations.Count) errors" }
          Write-Host "No PSScriptAnalyzer errors."
        ''')
      }
    }

    stage('Run Matrix for N seconds') {
      steps {
        script {
          int secs = (params.SECONDS as Integer)
          timeout(time: secs, unit: 'SECONDS') {
            // Pipe all output to a log we can archive afterwards
            pwsh(label: 'Matrix', script: "& './${params.SCRIPT}' 2>&1 | Tee-Object -FilePath matrix.log")
          }
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'matrix.log,pssa.txt', allowEmptyArchive: true, fingerprint: true
      echo "Artifacts archived (matrix.log, pssa.txt)."
    }
  }
}
