node{
    def project = 'itshakeli' 
    def appName = 'flask-signup'
    def imageTag = "${project}/${appName}:v_${env.BUILD_NUMBER}"
    def newApp
    
    currentBuild.result = "SUCCESS"

    try {

        stage ('Checkout'){
           checkout scm
        }

        stage ('Docker Build'){

            //sh './dockerBuild.sh'
            //sh ("docker build -t ${imageTag} --pull=true .")
            echo 'Build docker image'
            newApp = docker.build "${imageTag}"
            
            //sh("sudo docker build -t ${imageTag} .")
        }
        stage ('Test image'){
        // run some tests on it (see below), then if everything looks good:
        }
        stage ('Push to Repo'){

            echo 'Push to Repo'
            newApp.push 'latest'
            //sh './dockerPushToRepo.sh'
        }
        stage('Deploy'){
            
            def SERVICE_NAME="flask-signup-service"
            def IMAGE_VERSION="v_"${env.BUILD_NUMBER}
            def TASK_FAMILY="flask-signup"

            echo "Start Deploy " 
            sh pwd

            # Create a new task definition for this build
            sh 'sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" flask-signup.json > flask-signup-v_${BUILD_NUMBER}.json'
            sh 'aws ecs register-task-definition --family flask-signup --cli-input-json file://flask-signup-v_${BUILD_NUMBER}.json'

            # Update the service with the new task definition and desired count
            def TASK_REVISION= sh `aws ecs describe-task-definition --task-definition flask-signup | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
            def DESIRED_COUNT= sh `aws ecs describe-services --services ${SERVICE_NAME} | egrep "desiredCount" |tail -1| tr "/" " " | awk '{print $2}' | sed 's/,$//'`
            
            if DESIRED_COUNT = "0" 
                DESIRED_COUNT= "1"
            
            echo "debug 2"
            #DESIRED_COUNT=1

            sh 'aws ecs update-service --cluster default --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}'

        }
        
        stage ('Cleanup'){
            
        }
            
    }
    catch (err) {

        currentBuild.result = "FAILURE"

         
        throw err
    }

}
  
