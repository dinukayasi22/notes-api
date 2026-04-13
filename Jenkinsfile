pipeline {
    agent any

    environment {
        APP_DIR    = '/home/ubuntu/notes-api'
        REPO_URL   = 'https://github.com/your-username/notes-api.git'
        BRANCH     = 'main'
        IMAGE_NAME = 'notes-api'
    }

    stages {

        // ─── Stage 1: Clone or Pull Latest Code ──────
        stage('Checkout') {
            steps {
                echo '📥 Pulling latest code from GitHub...'
                git branch: "${BRANCH}",
                    url: "${REPO_URL}"
            }
        }

        // ─── Stage 2: Verify Required Tools ──────────
        stage('Verify Tools') {
            steps {
                echo '🔍 Verifying Docker is available...'
                sh 'docker --version'
                sh 'docker compose version'
            }
        }

        // ─── Stage 3: Build Docker Image ─────────────
        stage('Build') {
            steps {
                echo '🐳 Building Docker image...'
                sh 'docker compose build'
            }
        }

        // ─── Stage 4: Stop Old Containers ────────────
        stage('Stop Old Containers') {
            steps {
                echo '🛑 Stopping existing containers...'
                sh 'docker compose down || true'
            }
        }

        // ─── Stage 5: Deploy ──────────────────────────
        stage('Deploy') {
            steps {
                echo '🚀 Deploying app...'
                sh 'docker compose up -d'
            }
        }

        // ─── Stage 6: Health Check ────────────────────
        stage('Health Check') {
            steps {
                echo '❤️ Running health check...'
                sh '''
                    sleep 5
                    curl -f http://localhost:5000/api/health || exit 1
                    echo "✅ App is healthy!"
                '''
            }
        }

        // ─── Stage 7: Cleanup ─────────────────────────
        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning up unused Docker images...'
                sh 'docker image prune -f'
            }
        }
    }

    // ─── Post Actions ─────────────────────────────────
    post {
        success {
            echo '🎉 Pipeline completed successfully! App is live.'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs above.'
        }
        always {
            echo '📋 Pipeline finished. Check console output for details.'
        }
    }
}