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


### Update 1st May:
Following this to setup something without helm
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-kubernetes-monitoring-stack-with-prometheus-grafana-and-alertmanager-on-digitalocean

1. Creating a separate namespace to install,
Kubectl apply -f 01-namespace.yaml

2. export APP_INSTANCE_NAME=monitoring

3. export NAMESPACE=monitoring

4. export GRAFANA_GENERATED_PASSWORD="$(echo -n 'password' | base64)"

5. awk 'FNR==1 {print "---"}{print}' manifest/* \
 | envsubst '$APP_INSTANCE_NAME $NAMESPACE $GRAFANA_GENERATED_PASSWORD' \
 > "${APP_INSTANCE_NAME}_manifest.yaml"

6. It will generate a big fat manifest file. I updated the last line to include vol for 10 GB.

7. kubectl apply -f "${APP_INSTANCE_NAME}_manifest.yaml" --namespace "${NAMESPACE}"

8. kubectl apply -f grafana/03-ingress.yaml

9. I have copied the final monitoring_manifest.yaml here which can be applied just like that. Remember the password is password


### The above seems to be broken. Another try from prometheus operator from helm
helm install monitoring -f prometheus-values.yaml stable/prometheus-operator --namespace monitoring

monitoring      monitoring      1               2020-05-02 19:20:06.9907214 +0200 CEST  deployed        prometheus-operator-8.13.2      0.38.1
nfs-server      default         1               2020-05-01 21:51:55.6593139 +0200 CEST  deployed        nfs-server-provisioner-1.0.0    2.3.0