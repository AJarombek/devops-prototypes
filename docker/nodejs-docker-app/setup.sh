#!/usr/bin/env bash

# Setup for the Node.js Dockerized (Containerized) Application
# Author: Andrew Jarombek
# Date: 3/13/2019

npm init
npm i -S express

# Start the application
node main.js

# Containerize the application
docker image build -t nodejs-docker-app:latest .

# Confirm that a new image was created
docker image ls

# Inspect the docker image with the Node.js app
docker image inspect nodejs-docker-app:latest