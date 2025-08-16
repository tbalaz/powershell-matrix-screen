pipeline {
  agent any
  triggers { githubPush() } // optional when using the webhook + Git trigger, but harmless
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build & Test') {
      steps {
        sh 'echo "Build your app here"'
        // e.g. sh './gradlew test' or 'npm ci && npm test'
      }
    }
  }
}
