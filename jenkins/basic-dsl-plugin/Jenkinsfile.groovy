/**
 * A basic Jenkins Job that executes a Bash script
 * @author Andrew Jarombek
 * @since 8/31/2018
 */

node("master") {
    stage("Execute Bash Script") {

        // Log out the file structure of the jenkins job workspace
        sh """
            pwd
            ls -la
            ls -la ../
            ls -la ../Hello_World/
            ls -la ../Hello_World@script/
            ls -la ../Hello_World@tmp/
        """

        // Give Jenkins access to a bash script and then execute it
        sh """
            chmod +x ../Hello_World@script/jenkins/basic-dsl-plugin/script.sh
            ../Hello_World@script/jenkins/basic-dsl-plugin/script.sh
        """
    }
}