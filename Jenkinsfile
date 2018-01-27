#! groovy

node ('Slave') { 

	stage ('Checkout') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'f1b23df2-9714-46fc-a220-d47d41406718', url: 'git@github.com:mickeysh/session-ci-cd-jenkins']]]) 
	}
	stage ('Test') {
        sh 'ruby app/tc_ruby_app.rb'
        sh 'ls -ltrh test/reports'
    }
    stage ('Build') {
        sh ''' 
        sudo docker build --no-cache -t localhost:5000/opsschool_dummy_app:latest .
        sudo docker push localhost:5000/opsschool_dummy_app:latest
        sudo docker-compose stop

        if [!"$(sudo docker ps -q -f name=opsschool_dummy_app)"]; then
            sudo docker rm -f opsschool_dummy_app
        fi 
        '''		
    }
    stage ('Deploy') {
        sh 'sudo docker pull localhost:5000/opsschool_dummy_app:latest'
        sh 'sudo docker-compose up -d'
    }    

	junit 'test/reports/*.xml' 
}
