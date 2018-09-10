/**
 * Create a new freestyle job that builds other jobs.  This Jenkins job utilizes the DSL Plugin, allowing jobs to
 * be configured in code.
 * @author Andrew Jarombek
 * @since 8/30/2018
 */

// 'job' closure creates a new freestyle job.  This type of Job is usually configured in the Jenkins UI,
// however with the DSL Plugin all configuration is in a Groovy script.
job("Seed_Job") {

    // Parameters for users of the Jenkins job to pass in
    parameters {
        // String parameters are simply single line text inputs.  The arguments are as follows:
        // (1) -> the name of the parameter that can be used later in the script as a variable.
        // (2) -> the default value of the parameter.  Defaults to null.
        // (3) -> the description of the parameter which will be displayed in Jenkins.
        stringParam("job_dsl_repo", "", "Job DSL Repo")
        stringParam("job_dsl_path", "", "Location of Job DSL Groovy Script")
    }

    // SCM (Source Control Management) allows the Jenkins pipeline to use different version control systems
    scm {
        // In my case, I use Git
        git {
            // From the repository specified in one of the Jenkins job parameters, checkout from the master branch
            branch("master")
            remote {
                name("origin")
                url("\$job_dsl_repo")
            }
        }
    }

    // Add build steps to the freestyle job.
    steps {

        // Add a Job DSL Plugin step to the freestyle job.  This step runs a Groovy script to build Jenkins jobs.
        dsl {
            // Read the Groovy script to build Jenkins job from the Jenkins workspace
            external("\$job_dsl_path")
        }
    }
}