#!/bin/bash
set -e

apt update

apt install -y \
  docker.io \
  docker-compose \
  git

systemctl enable docker
systemctl start docker

mkdir -p /opt/devops

cd /opt/devops

git clone https://github.com/your-username/devops-project.git

cd devops-project/docker

docker compose up -d