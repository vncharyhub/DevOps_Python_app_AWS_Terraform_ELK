#!/bin/bash

# Update and install dependencies
sudo apt update && sudo apt install -y apt-transport-https curl gnupg

# Add Elasticsearch GPG key and repo
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor \
  -o /usr/share/keyrings/elastic-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] \
  https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee \
  /etc/apt/sources.list.d/elastic-8.x.list

# Install ELK components
sudo apt update && sudo apt install -y elasticsearch kibana logstash

# Enable services
sudo systemctl enable elasticsearch.service
sudo systemctl enable kibana.service
sudo systemctl enable logstash.service

# Start services
sudo systemctl start elasticsearch.service
sudo systemctl start kibana.service
sudo systemctl start logstash.service

echo "ELK Stack services started:"
echo " - Elasticsearch: http://<your-ip>:9200"
echo " - Kibana:        http://<your-ip>:5601"
