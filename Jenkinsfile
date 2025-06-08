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
                            wget https://downloads.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
                            sudo tar -xvzf apache-maven-3.8.4-bin.tar.gz -C /opt/
                            sudo ln -s /opt/apache-maven-3.8.4 /opt/maven
                            echo "export PATH=/opt/maven/bin:$PATH" >> ~/.bashrc
                            source ~/.bashrc
                        '''
                    } else {
                        echo "✅ Maven is already installed: ${mavenInstalled}"
                    }
                }
            }
        }

        stage('Check & Install Tomcat') {
            steps {
                script {
                    def tomcatExists = fileExists("${TOMCAT_DIR}/bin/startup.sh")
                    if (!tomcatExists) {
                        sh '''
                            sudo apt update
                            sudo apt install -y default-jdk
                            wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.53/bin/apache-tomcat-9.0.53.tar.gz
                            sudo mkdir -p /opt
                            sudo tar -xvzf apache-tomcat-9.0.53.tar.gz -C /opt/
                            sudo ln -s /opt/apache-tomcat-9.0.53 /opt/tomcat
                            sudo chmod +x /opt/tomcat/bin/*.sh
                        '''
                    } else {
                        echo "✅ Tomcat is already installed at ${TOMCAT_DIR}"
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
                git branch: 'main', url: 'https://github.com/YOUR_USERNAME/YOUR_REPO.git'
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
