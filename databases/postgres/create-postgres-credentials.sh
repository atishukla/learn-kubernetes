#!/bin/bash
# This script reads mysql.env and creates equivalent kubernetes secrets.
# It needs to be capable for creating k8s secrets by reading ENV variables as well,
#   as, that is the case with CI systems.
if [ ! -f ./postgres.env ]; then
  echo "Could not find ENV variables file for postgres - ./postgres.env"
  exit 1
fi

echo "First delete the old secret: mysql-credentials"
kubectl delete secret postgres-credentials  || true

echo "Found mysql.env file, creating kubernetes secret: postgres-credentials"
source ./postgres.env


kubectl create secret generic postgres-credentials \
  --from-literal=POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
  --from-literal=POSTGRES_USER=${POSTGRES_USER}