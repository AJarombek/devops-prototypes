#!/usr/bin/env bash

# User data for the kubernetes playground instance
# Author: Andrew Jarombek
# Date: 3/12/2019

echo "Beginning UserData Step"
apt-get update
apt-get -y install python-setuptools

mkdir aws-cfn-bootstrap-latest

curl https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz \
  | tar xz -C aws-cfn-bootstrap-latest --strip-components 1
easy_install aws-cfn-bootstrap-latest

/opt/aws/bin/cfn-init -v -s ${STACK_NAME} -r K8sPlaygroundInstance -c default --region ${REGION}
/opt/aws/bin/cfn-signal --exit-code $? --stack ${STACK_NAME} --resource K8sPlaygroundInstance --region ${REGION}

echo "Finishing UserData Step"