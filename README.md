# Terraform-Based DevOps Automation on Google Cloud

## Project Overview

This project demonstrates a complete DevOps Proof of Concept (PoC) using **Terraform** as Infrastructure as Code (IaC) to provision and automate the deployment of a CI/CD platform on Google Cloud Platform (GCP).

The infrastructure provisions a Compute Engine VM that automatically installs and configures:

- Docker
- Docker Compose
- Jenkins
- SonarQube
- NGINX Reverse Proxy

The Jenkins pipeline performs:

1. Source Code Checkout from GitHub
2. SonarQube Static Code Analysis
3. Unit Test Execution
4. Docker Image Build
5. Push Docker Image to Google Container Registry (GCR)
6. Deploy Updated Container

---

# Architecture

```text
                    +----------------+
                    |    GitHub      |
                    +--------+-------+
                             |
                             |
                             v
                    +----------------+
                    |    Jenkins     |
                    |   CI/CD Tool   |
                    +--------+-------+
                             |
         ------------------------------------------
         |                    |                   |
         |                    |                   |
         v                    v                   v

 +---------------+    +---------------+   +---------------+
 |  SonarQube    |    | Docker Build  |   | Unit Testing  |
 | Code Quality  |    | & Packaging   |   | Python Tests  |
 +---------------+    +---------------+   +---------------+
                             |
                             |
                             v

                 +----------------------+
                 | Google Container     |
                 | Registry (GCR)       |
                 +----------+-----------+
                            |
                            |
                            v

                 +----------------------+
                 | Application Deploy   |
                 +----------------------+

```

---

# Infrastructure Components

| Component | Purpose |
|------------|----------|
| Terraform | Infrastructure Provisioning |
| Google Compute Engine | VM Hosting |
| VPC Network | Isolated Networking |
| Firewall Rules | Port Management |
| Docker | Container Runtime |
| Docker Compose | Container Orchestration |
| Jenkins | CI/CD Automation |
| SonarQube | Code Quality Analysis |
| NGINX | Reverse Proxy |
| Google Container Registry | Docker Image Storage |

---

# Terraform Project Structure

```text
terraform/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
├── startup-script.sh
│
├── docker-compose.yml
│
└── nginx/
    └── default.conf
```

---

# Terraform Resources Created

## Networking

- Custom VPC
- Custom Subnet
- Firewall Rules

## Compute

- Compute Engine VM

## Startup Automation

Startup script performs:

- Docker Installation
- Docker Compose Installation
- Repository Clone
- Container Deployment
- Jenkins Startup
- SonarQube Startup
- NGINX Startup

---

# Prerequisites

## Local Machine

Install:

- Terraform
- Git
- Google Cloud SDK

Verify:

```bash
terraform --version
gcloud --version
git --version
```

---

# Authentication

Login to GCP:

```bash
gcloud auth application-default login
```

Set project:

```bash
gcloud config set project PROJECT_ID
```

---

# Deployment Steps

## 1. Clone Repository

```bash
git clone https://github.com/<your-repo>.git
cd terraform
```

---

## 2. Initialize Terraform

```bash
terraform init
```

---

## 3. Review Execution Plan

```bash
terraform plan
```

---

## 4. Provision Infrastructure

```bash
terraform apply
```

Approve when prompted:

```text
yes
```

---

## 5. Verify Resources

Check VM:

```bash
gcloud compute instances list
```

---

# Accessing Services

## Jenkins

```text
http://PUBLIC_IP/jenkins
```

---

## SonarQube

```text
http://PUBLIC_IP/sonar
```

---

# Jenkins Pipeline Stages

```text
GitHub Checkout
      ↓
SonarQube Scan
      ↓
Run Unit Tests
      ↓
Build Docker Image
      ↓
Push Image to GCR
      ↓
Deploy Container
      ↓
Success Notification
```

---

# Sample Jenkinsfile

```groovy
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/<repo>.git'
            }
        }

        stage('Sonar Scan') {
            steps {
                sh 'sonar-scanner'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python3 -m unittest discover'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t app:${BUILD_NUMBER} .'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push gcr.io/project-id/app:${BUILD_NUMBER}'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }
}
```

---

# Useful Terraform Commands

## Initialize

```bash
terraform init
```

## Validate

```bash
terraform validate
```

## Plan

```bash
terraform plan
```

## Apply

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# Terraform Concepts Demonstrated

## Infrastructure as Code (IaC)

Infrastructure is managed through code rather than manual configuration.

---

## Declarative Configuration

Terraform defines:

```text
What infrastructure should exist
```

instead of:

```text
How to create it step-by-step
```

---

## State Management

Terraform maintains:

```text
terraform.tfstate
```

to track deployed resources.

---

## Idempotency

Repeated executions of:

```bash
terraform apply
```

will not recreate unchanged resources.

---

# Troubleshooting

## Startup Script Logs

```bash
sudo journalctl -u google-startup-scripts.service
```

---

## Verify Docker

```bash
docker ps -a
```

---

## Verify Containers

```bash
docker compose ps
```

---

## Verify Jenkins

```bash
docker logs jenkins
```

---

## Verify SonarQube

```bash
docker logs sonarqube
```

---

# Security Improvements

Future enhancements:

- HTTPS using SSL/TLS
- Secret Manager Integration
- Remote Terraform State
- Service Accounts
- GitHub Webhooks
- Jenkins Agents
- Monitoring with Prometheus & Grafana

---

# Key Learnings

- Infrastructure as Code using Terraform
- Declarative Infrastructure Provisioning
- Docker Containerization
- Jenkins CI/CD Automation
- SonarQube Static Analysis
- GCP Infrastructure Management
- Reverse Proxy Configuration
- Container Registry Integration

---

# Author

DevOps Terraform Assessment Project

Google Cloud | Terraform | Docker | Jenkins | SonarQube | NGINX
