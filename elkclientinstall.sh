#!/bin/bash
#sudo mkdir -p /etc/pki/tls/certs

#sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/

# Install Filebeat Package

echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update

sudo apt-get install filebeat


# Configure Filebeat

# sudo vi /etc/filebeat/filebeat.yml

#filebeat:
 # prospectors:
  #  -
   #   paths:
    #    - /var/lib/docker/containers/39f943a385324a3ca3f95c7efef26f59a00fdc7e87f4c719b1c9732ed95b335a/39f943a385324a3ca3f95c7efef26f59a00fdc7e87f4c719b1c9732ed95b335a-json.log
     # document_type: syslog
#output:
 # logstash:
  #  hosts:
   #   - 10.5.0.4:5044

    #tls:
     # certificate_authorities: ["etc/pki/tls/certs/logstash-forwarder.crt"]
   # timeout: 15


#logging:
 # level: warning

sudo service filebeat restart

sudo update-rc.d filebeat defaults 95 10


