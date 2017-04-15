#!/bin/bash
SERVICE_NAME="flask-signup-service"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="flask-signup"
TASK_DEFINITION_FILE=flask-signup-v_${BUILD_NUMBER}.json

echo "start deploy"
pwd

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" flask-signup.json > ${TASK_DEFINITION_FILE}

aws ecs register-task-definition --family ${TASK_FAMILY} --cli-input-json file://${TASK_DEFINITION_FILE}

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition flask-signup | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} | egrep "desiredCount" |tail -1| tr "/" " " | awk '{print $2}' | sed 's/,$//'`

if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi


aws ecs update-service --cluster default --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
