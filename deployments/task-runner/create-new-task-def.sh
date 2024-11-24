#!/bin/bash

# Usage:
# ./update-ecs-task-def.sh <task-family-name> <container-name> <new-image>

set -e

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <task-family-name> <container-name> <new-image>"
  exit 1
fi

TASK_FAMILY=$1
CONTAINER_NAME_API=$2
NEW_IMAGE=$3

echo "Fetching the latest revision of the task definition for family: $TASK_FAMILY"
LATEST_TASK_DEF=$(aws ecs describe-task-definition --task-definition "$TASK_FAMILY")

# Extract the current container definitions and other properties
CONTAINER_DEFINITIONS=$(echo "$LATEST_TASK_DEF" | jq ".taskDefinition.containerDefinitions")
TASK_ROLE_ARN=$(echo "$LATEST_TASK_DEF" | jq ".taskDefinition.taskRoleArn")
EXECUTION_ROLE_ARN=$(echo "$LATEST_TASK_DEF" | jq ".taskDefinition.executionRoleArn")
NETWORK_MODE=$(echo "$LATEST_TASK_DEF" | jq ".taskDefinition.networkMode")

echo "Updating the container definition for container: $CONTAINER_NAME_API with new image: $NEW_IMAGE"
UPDATED_CONTAINER_DEFINITIONS=$(echo "$CONTAINER_DEFINITIONS" | jq -c --arg cn "$CONTAINER_NAME_API" --arg ni "$NEW_IMAGE" '
  map(if .name == $cn then .image = $ni else . end)
')

echo "Registering the new task definition..."
NEW_TASK_DEF_ARN=$(aws ecs register-task-definition --family $TASK_FAMILY --task-role-arn $TASK_ROLE_ARN --execution-role-arn "$EXECUTION_ROLE_ARN" --network-mode $NETWORK_MODE --container-definitions $UPDATED_CONTAINER_DEFINITIONS --query "taskDefinition.taskDefinitionArn" --output text)

echo "New task definition registered successfully: $NEW_TASK_DEF_ARN"
