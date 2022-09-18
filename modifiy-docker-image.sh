#!/bin/bash

############################################################
# Docker create command: creates a fresh new container from a docker image. However, it doesn’t run it immediately. 
#
# Docker start command: will start any stopped container. If you used docker create command to create a container, you can start it with this command.
#
# Docker run command: is a combination of create and start as it creates a new container and starts it immediately. In fact, 
# the docker run command can even pull an image from Docker Hub if it doesn’t find the mentioned image on your system
#                                                 #
############################################################

docker stop akhq_config_containe
docker rm akhq_config_containe
winpty docker create --name akhq_container tchiotludo/akhq:latest
docker cp application-akhq.yml akhq_container:/app
docker rmi tchiotludo/akhq-config:latest
docker commit akhq_container tchiotludo/akhq-config:latest
docker stop akhq_container
docker rm akhq_container
winpty docker run --name akhq_config_containe -d -p 8080:8080 tchiotludo/akhq-config:latest
docker logs akhq_config_containe
