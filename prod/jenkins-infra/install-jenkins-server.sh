#!/bin/bash
# Run this on the jenkins-server EC2 instance (Amazon Linux 2023).
# Designed to run unattended via Terraform user_data - retries transient
# failures and logs a clear pass/fail summary at the end.

set -e

# Retry helper: some dnf commands can fail transiently right at boot,
# before networking/DNS is fully warmed up. Retry a few times before
# giving up for real.
retry() {
  local n=1
  local max=5
  local delay=10
  until "$@"; do
    if [ $n -ge $max ]; then
      echo "Command failed after $n attempts: $*"
      return 1
    fi
    echo "Attempt $n failed, retrying in ${delay}s: $*"
    n=$((n+1))
    sleep $delay
  done
}

echo "=== Updating system packages ==="
retry sudo dnf update -y

echo "=== Installing Docker ==="
retry sudo dnf install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user
#sudo dnf install -y docker-compose-plugin || echo "docker-compose-plugin not available, skipping (not required)"

echo "=== Installing Java 21 (required by current Jenkins) ==="
retry sudo dnf install -y java-21-amazon-corretto

echo "=== Installing Git ==="
retry sudo dnf install -y git

echo "=== Installing wget ==="
retry sudo dnf install -y wget

echo "=== Installing Jenkins ==="
retry sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
retry sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
retry sudo dnf install -y jenkins

# Make sure nothing is squatting on 8080 before Jenkins tries to bind to it
# (defensive - shouldn't happen on a fresh instance, but costs nothing)
sudo fuser -k 8080/tcp 2>/dev/null || true

sudo systemctl enable --now jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# --- Verify Jenkins actually came up, and log a clear result ---
echo "=== Verifying Jenkins started ==="
for i in $(seq 1 12); do
  if sudo systemctl is-active --quiet jenkins; then
    echo "SUCCESS: Jenkins is active."
    break
  fi
  echo "Waiting for Jenkins to become active... ($i/12)"
  sleep 10
done

if sudo systemctl is-active --quiet jenkins; then
  echo "=== PROVISIONING COMPLETE - Jenkins is running ==="
else
  echo "=== PROVISIONING WARNING - Jenkins did NOT start successfully ==="
  echo "Run 'sudo journalctl -xeu jenkins.service --no-pager' to diagnose."
fi

echo ""
echo "Visit: http://<jenkins-server-public-ip>:8080"
echo "Initial admin password:"
echo "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "NEXT STEPS in the Jenkins UI:"
echo "  1. Unlock Jenkins with the password above"
echo "  2. Install suggested plugins"
echo "  3. Manage Jenkins -> Plugins -> install 'Docker Pipeline' and 'SSH Agent'"
