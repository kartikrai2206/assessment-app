#!/bin/bash
set -e

apt update

apt install -y docker.io openjdk-17-jdk docker-compose git

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -

sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > \
/etc/apt/sources.list.d/jenkins.list'

apt update
apt install -y jenkins

systemctl enable jenkins
systemctl start jenkins