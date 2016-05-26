#!/bin/bash

sudo mkdir -p /etc/pki/tls/certs

#sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/
cd ~

sudo wget https://github.com/jwilder/docker-gen/releases/download/0.7.0/docker-gen-linux-amd64-0.7.0.tar.gz

sudo mkdir /opt/docker-gen

sudo tar xvzf docker-gen-linux-amd64-0.7.0.tar.gz -C /opt/docker-gen

sudo mkdir /etc/docker-gen

sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/filebeat.tmpl -P /etc/docker-gen

sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/docker-gen.conf -P /etc/init



# Install Filebeat Package

echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update

sudo apt-get -y install filebeat





# Restart Filebeat as a service



sudo service filebeat restart

sudo update-rc.d filebeat defaults 95 10


