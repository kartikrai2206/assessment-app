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

git clone https://github.com/kartikrai2206/assessment-app.git

cd assessment-app/docker-poc

docker compose up -d