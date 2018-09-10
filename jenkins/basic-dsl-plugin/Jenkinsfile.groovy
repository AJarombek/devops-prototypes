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
            ls -la ../Hello_World/
            ls -la ../Hello_World@script/
            ls -la ../Hello_World@tmp/
        """

        sh "../Hello_World@script/jenkins/basic-dsl-plugin/script.sh"
    }
}