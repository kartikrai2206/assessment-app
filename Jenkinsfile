pipeline {
    agent any

    environment {
        IMAGE_NAME = "assess-1"
        PROJECT_ID = "test-learning-project-494008"
        GCR_REPO = "gcr.io/${PROJECT_ID}/${IMAGE_NAME}"
        TAG = "${BUILD_NUMBER}"
        //SONAR_HOST_IP = "34.14.181.26"       //FOR TEST-INSTANCE
        
        SONAR_HOST = "http://sonarqube:9000"
        // SONAR_PROJECT_KEY = terraform-poc-1

        SONARQUBE_ENV = "SonarQube"
        SONAR_TOKEN = credentials('sonar-token')
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
                    docker run --rm \
                    --network docker_default \
                    -v $(pwd):/usr/src \
                    sonarsource/sonar-scanner-cli \
                    -Dsonar.projectKey=terraform-poc-1 \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=${SONAR_HOST} \
                    -Dsonar.login=$SONAR_TOKEN
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