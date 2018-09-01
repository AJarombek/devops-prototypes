#!/usr/bin/env bash

# Setup local Jenkins server
# Author: Andrew Jarombek
# Date: 8/31/2018

# Download Generic Java Package - https://jenkins.io/download/
java -jar jenkins.war &
kill %1