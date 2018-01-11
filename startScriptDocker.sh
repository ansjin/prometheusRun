#!bin/bash
echo "setup"
sudo iptables -P INPUT ACCEPT
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
#docker Installation
sudo apt-get install -y docker-ce
sudo curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
#nodejs Installation
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
#prometheus Run
sudo rm -r /prometheus-data
sudo mkdir -p /prometheus-data
git clone https://github.com/ansjin/prometheusRun.git
cd prometheusRun
sudo cp prometheus.yml /prometheus-data/prometheus.yml
sudo docker run -d --net="host" --pid="host" quay.io/prometheus/node-exporter
sudo docker run -d --net="host" -v /prometheus-data:/prometheus-data prom/prometheus --config.file=/prometheus-data/prometheus.yml
sudo fuser -n tcp -k 8080
sudo fuser -n tcp -k 9001
#Microservice Run
git clone https://github.com/ansjin/microserviceTest.git
cd microserviceTest
sudo docker-compose up --build &
