#!/usr/bin/env groovy
pipeline{
    agent any

    //Define stages for the build process
    stages{
        //Define the test stage
        stage('Test'){
            //Define the docker image to use for the test stage
            agent{
                docker{
                    image 'maven:3.5.2-alpine'
                }
            }
            //Write the scripts to run in the node Docker container to test the application.
            //Since this is a groovy file we use the '''string''' syntax to define multi-line formatting.
            //Groovy will use the string EXACTLY as written in between the ''' characters. In this instance each
            //line between the ''' characters will be treated as separate lines of a shell script.
            steps{
                sh '''mvn test'''
            }
        }

        //Define the deploy stage
        stage('Deploy'){
            steps{
                //The Jenkins Declarative Pipeline does not provide functionality to deploy to a private
                //Docker registry. In order to deploy to the HDAP Docker registry we must write a custom Groovy
                //script using the Jenkins Scripting Pipeline. This is done by placing Groovy code with in a "script"
                //element. The script below registers the HDAP Docker registry with the Docker instance used by
                //the Jenkins Pipeline, builds a Docker image of the project, and pushes it to the registry.
                script{
                    docker.withRegistry('https://gt-build.hdap.gatech.edu'){
                        //Build and push the database image
                        def databaseImage = docker.build("gtfhir2:${env.BUILD_NUMBER}", "-f Dockerfile .")
                        databaseImage.push("${env.BUILD_NUMBER}")
                    }
                }
                script{
                    docker.withRegistry('https://797827902844.dkr.ecr.us-east-2.amazonaws.com', 'ecr:us-east-2:open-mdi-credential'){
                        //Build and push the database image
                        def openMdiImage = docker.build("om-java-ui-gtri-gt-fhir2:${env.BUILD_NUMBER}", "-f ./Dockerfile .")
                        openMdiImage.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        //Define stage to notify rancher
        stage('Notify'){
            steps{
                script{
                    rancher confirm: true, credentialId: 'gt-rancher-server', endpoint: 'https://gt-rancher.hdap.gatech.edu/v2-beta', environmentId: '1a7', environments: '', image: "gt-build.hdap.gatech.edu/gtfhir2:${env.BUILD_NUMBER}", ports: '', service: 'GT-FHIR-2/gtfhir2', timeout: 50
                    rancher confirm: true, credentialId: 'gt-rancher-server', endpoint: 'https://gt-rancher.hdap.gatech.edu/v2-beta', environmentId: '1a7', environments: '', image: "gt-build.hdap.gatech.edu/gtfhir2:${env.BUILD_NUMBER}", ports: '', service: 'MortalityReporting/gtfhir2', timeout: 50
                    rancher confirm: true, credentialId: 'gt-rancher-server', endpoint: 'https://gt-rancher.hdap.gatech.edu/v2-beta', environmentId: '1a7', environments: '', image: "gt-build.hdap.gatech.edu/gtfhir2:${env.BUILD_NUMBER}", ports: '', service: 'GT-FHIR-2/synpuffhirserver', timeout: 50
                    rancher confirm: true, credentialId: 'gt-rancher-server', endpoint: 'https://gt-rancher.hdap.gatech.edu/v2-beta', environmentId: '1a7', environments: '', image: "gt-build.hdap.gatech.edu/gtfhir2:${env.BUILD_NUMBER}", ports: '', service: 'GT-FHIR-2/smartfhir', timeout: 50
                }
            }
        }
    }
}
