#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Install Java 17
sudo apt install -y openjdk-17-jdk unzip wget postgresql postgresql-contrib

# Setup PostgreSQL for SonarQube
sudo -u postgres psql -c "CREATE USER sonar WITH PASSWORD 'sonar';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c "ALTER USER sonar WITH SUPERUSER;"

# Download SonarQube
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
sudo unzip sonarqube-10.5.1.90531.zip
sudo mv sonarqube-10.5.1.90531 sonarqube
sudo chown -R $USER:$USER /opt/sonarqube

# Run SonarQube
/opt/sonarqube/bin/linux-x86-64/sonar.sh start

echo "SonarQube is starting on http://<your-ip>:9000"
