#!/usr/bin/env bash

# Author: Andrew Jarombek
# Date: 6/12/2018
# Setting up Docker for the first time

# Displays the versions of both the docker client and server versions
docker version

# A docker image is a blueprint for a container
# Shows all the images - will be a blank list when no images have been pulled
docker image ls

# A docker container is a runtime instance of an image
docker container ls

# Pull an image onto the local docker host
# The ubuntu image has the basic ubuntu filesystem and some of the ubuntu utilities
docker pull ubuntu

# Once the ubuntu image has been pulled, an image will be shown from this command
docker image ls

# Start an instance of the ubuntu image
# The -it flag allows us to interact with the container in the current shell
# /bin/bash is the process to run in the container
docker container run -it ubuntu:latest /bin/bash

# ps displays the currently running processes.
# The only currently running process is bash (and ps while this command executes)
# Containers run much fewer processes than a full blown OS
ps -elf

# CTRL-P + CTRL-Q to run the container in the background
# You will now see a container instance running
docker container ls

# Reconnect to the running container
# quizzical_hawking is the name Docker gave to my container
# Specify to interact with the container in the current shell and run bash
docker container exec -it quizzical_hawking bash

# Stop the container
docker container stop quizzical_hawking

# Remove the container
docker container rm quizzical_hawking

# Make sure the container was removed.
# -a will show running and stopped containers
docker container ls -a