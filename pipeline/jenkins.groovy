pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick architecture')

    }
    stages {
        stage('Example') {
            steps {
                echo "Build for platform ${params.OS}"

                echo "Build for arch: ${params.ARCH}"

            }
        }

        stage("version"){
            steps {
                script {
                    echo 'GET VERSION'
                    sh 'go version'
                }
            }
        }

        stage("test"){
            steps {
                script {
                    echo 'TEST EXECUTION STARTED'
                    sh 'make test'
                }
            }
        }

        stage("build"){
            steps {
                script {
                    echo 'BUILD EXECUTION STARTED'
                    sh 'make build'
                }
            }
        }
        
        stage("image"){
            steps {
                script{
                    echo 'BUILD EXECUTION STARTED'
                    sh 'make image'
                }
            }
        }
        
        stage("push"){
            steps {
                script{
                    echo 'PUSH TO DOCKER_HUB'
                    docker.withRegistry( '', 'dockerhub' )
                    sh 'make push'
                }
            }
        }
<<<<<<< HEAD

        stage("version"){
            steps {
                script {
                    echo 'GET VERSION'
                    sh 'go version'
                }
            }
        }
        
        stage("build"){
            steps {
                script {
                    echo 'BUILD EXECUTION STARTED'
                    sh 'make build'
                }
            }
        }
        
        stage("image"){
            steps {
                script{
                    echo 'BUILD EXECUTION STARTED'
                    sh 'make image'
                }
            }
        }
        
        stage("push"){
            steps {
                script{
                    docker.withRegistry('', 'DOCKER_HUB')
                    sh 'make push'
                }
            }
        }
=======
>>>>>>> ef5a16b (add init jenkins pipeline)
    }
}
