#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade

# install Java
sudo apt-get install openjdk-7-jre-headless



# install elasticsearch

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch \
  | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" \
  | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list

  sudo apt-get update
sudo apt-get install elasticsearch

# set elasticsearch to run as a service

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service


# install logstash

echo "deb http://packages.elastic.co/logstash/2.1/debian stable main" \
  | sudo tee -a /etc/apt/sources.list

sudo apt-get -y update 
sudo apt-get install logstash

sudo update-rc.d logstash defaults 97 8

# start logstash

sudo service logstash start


# install kibana

wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
tar -xvf kibana*
cd kibana*
sudo mkdir -p /opt/kibana
sudo mv kibana-*/* /opt/kibana


# set kibana to run as a service

cd /etc/init.d && \
  sudo wget https://raw.githubusercontent.com/akabdog/scripts/master/kibana4_init \
  -O kibana4

sudo chmod +x /etc/init.d/kibana4
sudo update-rc.d kibana4 defaults 96 9
sudo service kibana4 start

