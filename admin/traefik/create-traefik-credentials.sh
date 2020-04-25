#!/bin/bash
# This script reads mysql.env and creates equivalent kubernetes secrets.
# It needs to be capable for creating k8s secrets by reading ENV variables as well,
#   as, that is the case with CI systems.
if [ ! -f ./traefik.env ]; then
  echo "Could not find ENV variables file for traefik - ./traefik.env"
  exit 1
fi

echo "First delete the old secret: traefik-credentials"
kubectl -n kube-system delete secret traefik-credentials  || true

echo "Found traefik.env file, creating kubernetes secret: traefik-credentials"
source ./traefik.env


kubectl -n kube-system create secret generic traefik-credentials \
  --from-literal=DO_AUTH_TOKEN=${DO_AUTH_TOKEN}