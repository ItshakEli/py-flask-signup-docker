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
            //newApp.tag("latest", false)
            newApp.push "v_${env.BUILD_NUMBER}"
            newApp.push 'latest'
            //sh './dockerPushToRepo.sh'
        }
        stage('Deploy'){
           
           sh './deployECS.sh'
        }
        
        stage ('Cleanup'){
            
        }
            
    }
    catch (err) {

        currentBuild.result = "FAILURE"
        
        throw err
    }

}
  
