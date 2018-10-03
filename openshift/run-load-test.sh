#!/bin/sh
set -o nounset -o errexit

# Run load test container against a deployed OpenShift environment. Used by the Load testing stage of the Jenkinsfile.
# Usage: ./run-load-test.sh staging latest

APP_NAME=greetings
ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}
IMAGESTREAM=`oc get imagestream ${APP_NAME} -o='jsonpath={.status.dockerImageRepository}'`

oc run ${APP_NAME}-load-${ENVIRONMENT}-${VERSION} \
  --image=${IMAGESTREAM}:${VERSION} \
  --rm=true \
  --attach=true \
  --restart=Never \
  --overrides='
  { "apiVersion":"v1",
    "spec":{
      "containers":[{
        "name": "'${APP_NAME}'-load-'${ENVIRONMENT}'-'${VERSION}'",
        "image": "'${IMAGESTREAM}':'${VERSION}'",
        "command":["yarn", "run", "load:verify"],
        "env":[{
          "name":"APP_ENV",
          "value":"'${ENVIRONMENT}'"
        }]
      }]
    }
  }'
