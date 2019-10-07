#!/bin/sh
set -eu
cd `dirname $0`

# Notify NewRelic of a deployment. Used by the Deploy stage of the Jenkinsfile.
# Usage: ./run-notify-newrelic.sh ${NEW_RELIC_APP_NAME} integration latest us-west-2

NEW_RELIC_APP_NAME=${1:-newrelic-app-name}
ENVIRONMENT=${2:-integration}
VERSION=${3:-latest}
REGION=${4:-us-west-2}

NEW_RELIC_API_KEY=$(aws ssm get-parameter \
    --region="${REGION}" \
    --name "/${ENVIRONMENT}/shared/newrelic-api-key" \
    --with-decryption \
    --output text \
    --query Parameter.Value)

NEW_RELIC_APP_ID=`curl -s -X GET "https://api.newrelic.com/v2/applications.json" \
  -H "X-Api-Key:${NEW_RELIC_API_KEY}" \
  -d "filter[name]=${NEW_RELIC_APP_NAME}" \
  | jq ".applications[] | select(.name == \"${NEW_RELIC_APP_NAME}\") | .id"`

if ! test "${NEW_RELIC_APP_ID}" = "null"
then
  curl -s -X POST "https://api.newrelic.com/v2/applications/${NEW_RELIC_APP_ID}/deployments.json" \
    -H "X-Api-Key: ${NEW_RELIC_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"deployment\":{\"revision\":\"${VERSION}\"}}"
else
  >&2 echo "No app ID found for ${NEW_RELIC_APP_NAME}. If this is not your first time running this deployment, check your NewRelic integration!"
fi
