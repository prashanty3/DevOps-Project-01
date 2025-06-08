pipeline {
    agent any

    environment {
        TOMCAT_DIR = '/opt/tomcat'
        MAVEN_HOME = '/opt/maven'
        WAR_NAME = 'yourapp.war'  // change this based on your actual WAR file
    }

    stages {

        stage('Check & Install Git') {
            steps {
                script {
                    def gitInstalled = sh(script: 'which git || echo "notfound"', returnStdout: true).trim()
                    if (gitInstalled == 'notfound') {
                        sh 'sudo apt update && sudo apt install -y git'
                    } else {
                        echo "✅ Git is already installed: ${gitInstalled}"
                    }
                }
            }
        }

        stage('Check & Install Maven') {
            steps {
                script {
                    def mavenInstalled = sh(script: 'which mvn || echo "notfound"', returnStdout: true).trim()
                    if (mavenInstalled == 'notfound') {
                        sh '''
                            sudo apt update
                            sudo apt install -y maven
                            mkdir -p ${MAVEN_HOME}
                        '''
                    } else {
                        echo "✅ Maven is already installed: ${mavenInstalled}"
                    }
                }
            }
        }

        stage('Setup Tomcat') {
            steps {
                script {
                    def tomcatExists = fileExists("${env.WORKSPACE}/tomcat/bin/startup.sh")
                    if (!tomcatExists) {
                        sh '''
                            mkdir -p tomcat
                            cd tomcat
                            curl -O https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz
                            curl -O https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz.sha512
                            expected=$(cat apache-tomcat-10.1.34.tar.gz.sha512 | awk '{print $1}')
                            actual=$(sha512sum apache-tomcat-10.1.34.tar.gz | awk '{print $1}')
                            [ "$expected" = "$actual" ] && echo "✅ Checksum verified." || (echo "❌ Checksum failed!" && exit 1)
                            tar xzvf apache-tomcat-10.1.34.tar.gz --strip-components=1
                            chmod +x bin/*.sh
                        '''
                    } else {
                        echo "✅ Tomcat already exists in workspace."
                    }
                }
            }
        }

        stage('Check & Install MySQL (optional)') {
            steps {
                script {
                    def mysqlInstalled = sh(script: 'which mysql || echo "notfound"', returnStdout: true).trim()
                    if (mysqlInstalled == 'notfound') {
                        sh 'sudo apt update && sudo apt install -y mysql-server'
                    } else {
                        echo "✅ MySQL is already installed: ${mysqlInstalled}"
                    }
                }
            }
        }

        stage('Check & Install Nginx (optional)') {
            steps {
                script {
                    def nginxInstalled = sh(script: 'which nginx || echo "notfound"', returnStdout: true).trim()
                    if (nginxInstalled == 'notfound') {
                        sh 'sudo apt update && sudo apt install -y nginx'
                    } else {
                        echo "✅ Nginx is already installed: ${nginxInstalled}"
                    }
                }
            }
        }

        stage('Clone Git Repository') {
            steps {
                echo 'Cloning repository...'
                git credentialsId: 'github-id',  // replace with your Jenkins credentials ID
                branch: 'main',  // replace with your desired branch
                url: 'https://github.com/prashanty3/DevOps-Project-01.git'
                echo '✅ Repository cloned successfully.'
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Something went wrong. Check logs.'
        }
    }
}
