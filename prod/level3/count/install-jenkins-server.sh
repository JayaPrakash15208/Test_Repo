#!/bin/bash
# Run this on the jenkins-server EC2 instance (Amazon Linux 2023).
# Usage: chmod +x install-jenkins-server.sh && ./install-jenkins-server.sh

set -e   # stop immediately if any command fails, instead of silently continuing

echo "=== Updating system packages ==="
sudo dnf update -y

echo "=== Installing Docker ==="
sudo dnf install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user
sudo dnf install -y docker-compose-plugin

echo "=== Installing Java 21 (required by current Jenkins) ==="
sudo dnf install -y java-21-amazon-corretto

echo "=== Installing Git ==="
sudo dnf install -y git

echo "=== Installing wget ==="
sudo dnf install -y wget

echo "=== Installing Jenkins ==="
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins
sudo systemctl enable --now jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

echo ""
echo "================================================="
echo " Done."
echo " Visit: http://<jenkins-server-public-ip>:8080"
echo " Initial admin password:"
echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo " NOTE: You just got added to the 'docker' group."
echo " Log out and back in (or run 'newgrp docker') before"
echo " running docker commands as ec2-user without sudo."
echo ""
echo " NEXT STEPS in the Jenkins UI:"
echo "   1. Unlock Jenkins with the password above"
echo "   2. Install suggested plugins"
echo "   3. Manage Jenkins -> Plugins -> install 'Docker Pipeline' and 'SSH Agent'"
echo "================================================="
