//node("ec2-fleet"){ 
node("master"){ 
    def project = 'itshakeli' 
    def appName = 'flask-signup'
    def imageTag = "${project}/${appName}:v_${env.BUILD_NUMBER}"
    def image
    
    currentBuild.result = "SUCCESS"

    try {

        stage ('Checkout'){
           checkout scm
        }

        stage ('Docker Build'){

            //sh './dockerBuild.sh'
            //sh ("docker build -t ${imageTag} --pull=true .")
            echo 'Build docker image'
            image = docker.build "${imageTag}"
            
            //sh("sudo docker build -t ${imageTag} .")
        }
        stage ('Test image'){
        // run some tests on it (see below), then if everything looks good:
        }
        stage ('Push to Repo'){

            echo 'Push to Repo'
            //newApp.tag("latest", false)
            image.push "v_${env.BUILD_NUMBER}"
            image.push 'latest'
            //sh './dockerPushToRepo.sh'
        } 
        //stage('Deploy'){
           
           //sh 'chmod u+x ./deployECS.sh'
           //sh './deployECS.sh'
        //}
               
            
        
        stage ('Cleanup'){
            
        }
            
    }
    catch (err) {

        currentBuild.result = "FAILURE"
        notifyFailed()
        throw err
    }
}

def notifyFailed() {
  emailext (
      subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>"""      
    )
}

node("master"){
try{
     stage('Deploy'){
           checkout scm
           sh 'chmod u+x ./deployECS.sh'
           sh './deployECS.sh'
     }
     stage('JIRA'){
	//def jiraJql = 'sprint in openSprints ()'
	def jiraIssues = [];
		      
        jiraIssues = jiraIssueSelector(issueSelector: [$class: 'DefaultIssueSelector'])
	//jiraIssues = jiraIssueSelector(issueSelector: [$class: 'JqlIssueSelector', jql: jiraJql])
        
        //for (jiraIssue in jiraIssues) {
	for ( int i = 0; i < jiraIssues.size(); i++ ) {     
		jiraIssue = jiraIssues.getAt(i)
		echo "Jira Issue: " + jiraIssue
	        jiraComment(issueKey: jiraIssue, body: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) built. Please go to ${env.BUILD_URL}."  )
	}//for
     }//stage
} catch (err) {
        currentBuild.result = "FAILURE"
        notifyFailed()
        throw err
  }
}//node 
