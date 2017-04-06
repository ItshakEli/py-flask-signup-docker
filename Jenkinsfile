node{


    currentBuild.result = "SUCCESS"

    try {

       stage 'Checkout'

            checkout scm

       stage 'Test'

           
       stage 'Build Docker'

            //sh './dockerBuild.sh'

       stage 'Deploy'

            echo 'Push to Repo'
            //sh './dockerPushToRepo.sh'

            
       stage 'Cleanup'

            
        }


    catch (err) {

        currentBuild.result = "FAILURE"

         
        throw err
    }

}
  
