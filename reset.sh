#!bin/bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
sudo fuser -n tcp -k 8080
sudo fuser -n tcp -k 9001
