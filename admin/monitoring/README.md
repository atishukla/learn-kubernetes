### Setup monitoring for our cluster

- We will use helm for this

- We deploy the resources in seprate namespace

- Update helm repo
helm repo update


- Install helm prometheus
helm install prometheus stable/prometheus --namespace monitoring

- Now we prometheus data source for grafana before hand

- We create configmap for the same. More details on the specs there can be found as comments there.
  Make sure to check them out as we may need to adapt it
kubectl apply -f grafana/02-config.yaml

- Override Grafana value
When Grafana gets deployed and the provisioner runs, the data source provisioner is deactivated. We need to activate it so it searches for our config maps.

We need to create our own values.yml file to override the datasources search value, so when Grafana is deployed it will search our datasource.yml definition and inject it.
helm install grafana stable/grafana -f grafana/values.yml --namespace monitoring

- Get the Grafana Password
kubectl get secret \
    --namespace monitoring \
    grafana \
    -o jsonpath="{.data.admin-password}" \
    | base64 --decode ; echo

- apply ingress
kubectl apply -f grafana/03-ingress.yaml

- you will see all is populated and datasource and installation is now striked.

- We need to install dashboard now
Grafana has a long list of prebuilt dashboard here: 
https://grafana.com/dashboards
- We will use this one https://grafana.com/grafana/dashboards/1860

- From grafana UI click dashboard - manager - import and give id as 1860