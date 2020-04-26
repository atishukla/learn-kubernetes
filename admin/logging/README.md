### Setup logging in the cluster

#### Common setup
1. create its own namespace
kubectl apply -f namespace.yaml

##### Setup elastic search
2. create the stateful set for elasticsearch
kubectl apply -f elasticsearch/02-statefulset.yaml

3. create the service for the elasticsearch
kubectl apply -f elasticsearch/03-service.yaml

4. Verify if the elastic search is setup correctly
kubectl port-forward svc/elasticsearch 9200 -n logging

5. Check localhost:9200 to see if it works correctly

#### Setup kibana
1. kubectl apply -f kibana/01-deployment.yaml

2. kubectl apply -f kibana/02-service.yaml

3. kubectl port-forward svc/kibana 5601 -n logging

#### Setup fluentd

1. It will run as a daemonset to collect all the logs

2. It will first need to have service account
kubectl apply -f fluentd/01-service-account.yaml