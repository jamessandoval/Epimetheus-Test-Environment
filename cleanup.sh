#!/bin/bash

docker-compose stop
docker-compose rm

# Cleanup docker containers

docker rmi docker-jmeter-cluster_slave --force
docker rmi docker-jmeter-cluster_master --force
#docker rmi jmeter-base --force

# Cleanup hub

docker kill selenium-hub
docker rmi selenium/node-chrome:3.141.59-gold --force
docker rmi selenium/hub:3.141.59-gold --force

# remove unused images
docker system prune -f

# Stop Everything
docker kill $(docker ps -q)
