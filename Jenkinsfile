node{
    def project = 'itshakeli' 
    def appName = 'flask-signup'
    def imageTag = "${project}/${appName}:v_${env.BUILD_NUMBER}"
    currentBuild.result = "SUCCESS"

    try {

        stage ('Checkout'){
           checkout scm
        }

        stage ('Docker Build'){

            //sh './dockerBuild.sh'
            //sh ("docker build -t ${imageTag} --pull=true .")
            echo 'Build docker image'
            def newApp = docker.build "${imageTag}"
            newApp.push 'latest'
            //sh("sudo docker build -t ${imageTag} .")
        }
        stage ('Test image'){
        // run some tests on it (see below), then if everything looks good:
        }
        stage ('Deploy'){

            echo 'Push to Repo'
            newApp.push 'latest'
            //sh './dockerPushToRepo.sh'
        }
            
        stage ('Cleanup'){
        }
            
    }
    catch (err) {

        currentBuild.result = "FAILURE"

         
        throw err
    }

}
  
