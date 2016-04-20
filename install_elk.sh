#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install wget

# install Java

sudo apt-get install openjdk-8-jre-headless



# install elasticsearch

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list

sudo apt-get update
sudo apt-get -y install elasticsearch


# set elasticsearch to run as a service

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

#Elasticsearch status check

curl -X GET http://localhost:9200


# install logstash

echo "deb http://packages.elastic.co/logstash/2.2/debian stable main" | sudo tee -a /etc/apt/sources.list/logstash-2.2.x.list

sudo apt-get -y update

sudo apt-get -y install logstash

#User should add ELK Server IP address to SubjectAltName in /etc/pki/tls/openssl.cnf under "[v3_ca]" section

# Create SSL Certificate

cd /etc/ssl/

openssl req -x509 -days 365 -batch -nodes -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt

# Configure Logstash

sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/logstash.conf > /etc/logstash/conf.d/logstash.conf


# start logstash as a service

sudo /bin/systemctl start logstash.service


# install kibana

sudo wget https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
tar -zxvf kibana-4.1.1-linux-x64.tar.gz
mv kibana-4.1.1-linux-x64 /opt/kibana4
sed -i 's/#pid_file/pid_file/g' /opt/kibana4/config/kibana.yml


sudo wget https://raw.githubusercontent.com/SysSudharsan/ELK/master/kibana4.service > /etc/systemd/system/kibana4.service

# enable kibana to start automatically at system startup.

sudo /bin/systemctl start kibana4.service

sudo /bin/systemctl enable kibana4.service


