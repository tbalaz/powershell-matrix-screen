pipeline {
  agent any
  options { timestamps() }
  triggers { githubPush() }  // react to GitHub webhooks
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Run matrix-screen.ps1') {
      steps {
        // Kill after 10s so the build doesn't run forever if the script loops
        timeout(time: 10, unit: 'SECONDS') {
          sh 'pwsh -NoLogo -NoProfile -File ./matrix-screen.ps1'
        }
      }
    }
    stage('Run matrix-screen-2.0.ps1') {
      steps {
        timeout(time: 10, unit: 'SECONDS') {
          sh 'pwsh -NoLogo -NoProfile -File ./matrix-screen-2.0.ps1'
        }
      }
    }
  }
  post {
    always { echo "Done." }
  }
}
