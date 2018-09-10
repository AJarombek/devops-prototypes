/**
 * A basic Jenkins Job that executes a Bash script
 * @author Andrew Jarombek
 * @since 8/31/2018
 */

node("master") {
    stage("Execute Bash Script") {

        sh """
            pwd
            ls -la
            ls -la ../
        """

        sh "./jenkins/basic-dsl-plugin/script.sh"
    }
}