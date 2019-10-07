#!/bin/sh
# Creates secrets in the application namespace.
# Used by the Deploy stage of the Jenkinsfile.
# Usage: ./run-secret.sh integration us-west-2

set -eua
cd `dirname $0`
ENVIRONMENT=${1:-integration}
REGION=${2:-us-west-2}

# Newrelic License
NEW_RELIC_LICENSE_KEY=$(aws ssm get-parameter \
    --region="${REGION}" \
    --name "/${ENVIRONMENT}/shared/newrelic-license-key" \
    --with-decryption \
    --output text \
    --query Parameter.Value)

kubectl create secret generic newrelic-license \
    --from-literal=key="${NEW_RELIC_LICENSE_KEY}" \
    --dry-run -o yaml | kubectl apply -f -
