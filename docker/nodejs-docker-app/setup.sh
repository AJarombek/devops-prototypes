#!/usr/bin/env bash

# Setup for the Node.js Dockerized (Containerized) Application
# Author: Andrew Jarombek
# Date: 3/13/2019

# -----------
# Local Setup
# -----------

npm init
npm i -S express

# Start the application
node main.js

# -----------------------
# Docker Playground Setup
# -----------------------

git clone https://github.com/AJarombek/devops-prototypes.git
cd devops-prototypes/docker/nodejs-docker-app/

# Containerize the application
docker image build -t nodejs-docker-app:latest .

# Confirm that a new image was created
docker image ls

# Inspect the docker image with the Node.js app
docker image inspect nodejs-docker-app:latest

# Create ECR repository for the Docker image
aws ecr create-repository --repository-name nodejs-docker-app --region us-east-1

# Authenticate docker with the Amazon ECR registry.  This returns a command with an AuthToken.
aws ecr get-login --region us-east-1 --no-include-email

# Run the command returned by 'aws ecr get-login'.  The AuthToken is long so I didn't include it here
docker login -u AWS -p ${AuthToken} https://739088120071.dkr.ecr.us-east-1.amazonaws.com

# Retrieve the nodejs-docker-app repository url on ECR
Repo="$(aws ecr describe-repositories --repository-names nodejs-docker-app --region us-east-1 \
    --query "repositories[0].repositoryUri" --output text)"

# Re-Tag the nodejs-docker-app:latest image with the ECR repository
docker image tag nodejs-docker-app:latest ${Repo}:latest

# Finally, push the image onto ECR
docker image push ${Repo}:latest

# Next run the image, creating a container
docker container run --name nodejs-app -p 80:3000 nodejs-docker-app:latest

# Prove that the container is created
docker container ls
docker container ls -a

# View the logs for the container in case errors occur
docker logs nodejs-app

# Remove the container
docker container rm nodejs-app