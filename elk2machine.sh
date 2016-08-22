#!/bin/bash
sudo apt-get -y update

sudo apt-get -y install wget

# install Java

sudo apt-get -y install openjdk-7-jre-headless



# install elasticsearch

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb http://packages.elastic.co/elasticsearch/5.0.0-alpha/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-5.0.0-alpha.list

sudo apt-get update
sudo apt-get -y install elasticsearch


# set elasticsearch to run as a service

sudo service elasticsearch restart

sudo update-rc.d elasticsearch defaults 95 10


#Elasticsearch status check

curl -X GET http://localhost:9200





# install kibana


echo "deb http://packages.elastic.co/kibana/5.0.0-alpha/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-5.0.0-alpha.list

sudo apt-get update

sudo apt-get -y install kibana

sudo update-rc.d kibana defaults 96 9

sudo service kibana start

# install X-Pack

sudo cd /usr/share/elasticsearch
sudo bin/elasticsearch-plugin install x-pack


# install nginx

sudo apt-get -y install nginx apache2-utils

# sudo htpasswd -c /etc/nginx/htpasswd.users kibanatestuser

sudo rm -r /etc/nginx/sites-available/default

sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/default -P /etc/nginx/sites-available/


sudo service nginx restart





# install logstash

echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list.d/logstash-2.3.x.list

sudo apt-get -y update

sudo apt-get -y install logstash



# Create SSL Certificate

sudo mkdir -p /etc/pki/tls/certs

sudo mkdir /etc/pki/tls/private




sudo sed -i 's/# Extensions for a typical CA/subjectAltName = IP: 10.5.0.5/g' /etc/ssl/openssl.cnf

cd /etc/pki/tls

sudo openssl req -config /etc/ssl/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt



# Configure Logstash

cd ~

sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/02-beats-input.conf -P /etc/logstash/conf.d

sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/30-elasticsearch-output.conf -P /etc/logstash/conf.d



# start logstash as a service

sudo service logstash restart

sudo update-rc.d logstash defaults 96 9


# Load Kibana Dashboards


cd ~

curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip

sudo apt-get -y install unzip

unzip beats-dashboards-*.zip

cd beats-dashboards-*

./load.sh


# Load Filebeat Index Template in Elasticsearch

cd ~

curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json

curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json


# Add Client Servers

# Copy SSL Certificate

# scp /etc/pki/tls/certs/logstash-forwarder.crt user@client_server_private_address:/tmp









