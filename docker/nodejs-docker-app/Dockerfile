# Dockerfile for the nodejs-docker-app
# Author: Andrew Jarombek
# Date: 3/13/2019

# The 'FROM' instruction defines the base layer of the image.
# This image uses the Alpine Linux distro as the base image.
FROM alpine

# The 'LABEL' instruction is used to add metadata about the image.
LABEL maintainer="andrew@jarombek.com"

# The 'RUN' instruction adds a new layer to an image.  It executes commands on the image.
RUN apk add --update nodejs nodejs-npm

# The 'COPY' instruction copies files in the build context onto the image
COPY . /src

# The 'WORKDIR' instruction sets the directory to execute the remaining commands from
WORKDIR /src

# Install npm inside the /src directory
RUN npm install

# The 'EXPOSE' instruction determines which port is exposed for the containerized application
EXPOSE 3000

# The 'ENTRYPOINT' instruction declares the main application that the container runs
ENTRYPOINT ["node", "./app.js"]