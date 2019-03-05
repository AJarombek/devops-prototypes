#!/usr/bin/env bash

# Setup local Jenkins server
# Author: Andrew Jarombek
# Date: 8/31/2018

# Jenkins only works with Java 8 - so if multiple versions of Java are installed you must make sure to invoke Java 8
# Check all the installed JDKs (on Mac)
/usr/libexec/java_home -V

# Change the default Java version to the major version 1.8
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
java -version

# Download Generic Java Package - https://jenkins.io/download/
java -jar jenkins.war &

# If you want to start Jenkins at a port other than 8080
java -jar jenkins.war --httpPort=8085

kill %1