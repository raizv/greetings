#!/bin/sh
set -eua
cd `dirname $0`

# Used by the Deploy stage of the Jenkinsfile.
# Usage: ./run-deploy.sh app_name integration f90117e9af583e6f93c3c5f8f8b4d24467786b8d

APP_NAME=$1
ENVIRONMENT=${2:-integration}
VERSION=${3:-latest}
REGION=${4:-us-west-2}

ROLE_ARN=$(aws cloudformation describe-stacks --region "${REGION}" \
  --stack-name "dynamic-traffic-allocation-dripw-iam-${ENVIRONMENT}" \
  --query 'Stacks[0].Outputs[?OutputKey==`DockerRoleArn`].OutputValue' \
  --output text)

ECR_URL=$(aws ecr describe-repositories \
  --repository-names "${APP_NAME}" \
  --region us-west-2 \
  | jq -r '.repositories[0].repositoryUri')

# check if image version exists in ECR
if aws ecr describe-images --repository-name "${APP_NAME}" --region us-west-2 | jq -r '.imageDetails[].imageTags'| grep "${VERSION}" > /dev/null 2>&1
then
  # render and apply helm template
  helm template chart -f "chart/${ENVIRONMENT}.yaml" \
    --set image.version="${VERSION}" \
    --set roleArn="${ROLE_ARN}"| kubectl apply -f -
  
  # check status of deployment
  kubectl rollout status deployment "${APP_NAME}"
else
  echo "ERROR: Image ${ECR_URL}:${VERSION} is not found in ECR"
  exit 1
fi
