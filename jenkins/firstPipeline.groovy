// Author: Andrew Jarombek
// Date: 7/1/2018
// A Hello World type of Jenkins pipeline

node ('master') {
    stage('Source') {
        // Get the source code for the webpack/react seed project
        git 'https://github.com/AJarombek/react-webpack-seed.git'
    }
    stage('Print') {
        sh 'echo Hello from Jenkins!'
    }
}