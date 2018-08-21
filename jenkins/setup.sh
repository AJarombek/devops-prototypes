#!/usr/bin/env bash

# Author: Andrew Jarombek
# Date: 7/1/2018

# Pull the jenkins image onto the local docker host
docker pull jenkins/jenkins:lts

# View all images - Jenkins should now be one of them
docker image ls

# Start an instance of the jenkins image
docker container run -d -p 8081:8080 -p 50000:50000 jenkins/jenkins:lts

# Make sure the container was created
docker container ls

# Check the logs to find the admin password
docker logs gifted_swartz