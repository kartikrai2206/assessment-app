pipeline {
    agent any

    environment {
        IMAGE_NAME = "assess-1"
        PROJECT_ID = "test-learning-project-494008"
        GCR_REPO = "gcr.io/${PROJECT_ID}/${IMAGE_NAME}"
        TAG = "${BUILD_NUMBER}"
        SONAR_HOST_IP = "34.14.181.26"

        SONARQUBE_ENV = "SonarQube"
    }

    stages {

        stage('Pull Code from GitHub') {
            steps {
                git branch: 'main',
                url: 'https://github.com/kartikrai2206/assessment-app.git'
            }
        }

        stage('Run Sonar Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh '''
                    /opt/sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner \
                    -Dsonar.projectKey=assess-first \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://${SONAR_HOST_IP}/sonar \
                    -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }  
        }

        
        stage('Run Test Cases') {
            steps {
                sh '''
                python3 -m unittest discover
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME}:${TAG} .
                '''
            }
        }

        
        stage('Push Image to GCR') {
            steps {
                sh '''
                docker tag ${IMAGE_NAME}:${TAG} ${GCR_REPO}:${TAG}

                docker push ${GCR_REPO}:${TAG}
                '''
            }
        }

        stage('Deploy Stage') {
            steps {
                sh '''
                docker pull ${GCR_REPO}:${TAG}

                docker stop my-container || true
                docker rm my-container || true

                docker run -d \
                  --name my-container \
                  ${GCR_REPO}:${TAG} hello
                '''
            }
        }
    }

    post {
        success {
            echo 'Application deployed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}