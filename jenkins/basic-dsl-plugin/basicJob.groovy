/**
 * Setup a basic Jenkins pipeline job
 * @author: Andrew Jarombek
 * @since: 8/31/2018
 */

// 'pipelineJob' creates a new pipeline Job which uses a Groovy script to execute
pipelineJob("Hello_World") {

    // Define the pipeline script which is located in Git
    definition {
        cpsScm {
            scm {
                git {
                    branch("jenkins-testing")
                    remote {
                        name("origin")
                        url("https://github.com/AJarombek/devops-prototypes.git")
                    }
                }
            }
            // The path within source control to the pipeline jobs Jenkins file
            scriptPath("jenkins/basic-dsl-plugin/Jenkinsfile.groovy")
        }
    }
}