### Overview

Startup code for working with the Jenkins Job DSL Plugin.  The Job DSL Plugin allows Jenkins Jobs to be written 
declaratively in Groovy code.

### Files

| Filename             | Description                                                                                |
|----------------------|--------------------------------------------------------------------------------------------|
| `basicJob.groovy`    | A Job DSL script for a basic Jenkins job.  Uses `Jenkinsfile.groovy`.                      |
| `jenkins.sh`         | Bash script to run a Jenkins server locally.                                               |
| `Jenkinsfile.groovy` | Pipeline for a basic Jenkins job.                                                          |
| `script.sh`          | Bash script invoked from `Jenkinsfile.groovy`.                                             |
| `seedJob.groovy`     | A Job DSL script for a Freestyle Jenkins job.  Creates a seed job to generate other jobs.  |