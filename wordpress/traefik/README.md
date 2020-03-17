### Deploy Traefik

1. Create config map for traefik using file traefik.toml
```
kubectl  --namespace=kube-system  create configmap configmap-traefik-toml --from-file=traefik.toml
```
2. Create the admin password for traefik dashboard using htpasswd
```
htpasswd -c -b dashboard-users.htpasswd admin <YOUR PASSWORD>
```
3. Create config map for the traefik.toml file to be used in traefik deployment
```
kubectl  --namespace=kube-system  create configmap configmap-traefik-toml --from-file=traefik.toml
```
4. Create secret for the dashboard admin user and password
```
kubectl  --namespace=kube-system  create secret generic secret-traefik-dashboard-users --from-file=dashboard-users.htpasswd
```
5. Create rbac
```
kubectl apply -f traefik-rbac.yaml
```
6. Apply traefik deployment
```
kubectl apply -f traefik-deployment.yaml
```
7. Set up your DNS to mark CNAME record for wild card to traefik hostname and it to alias to LB
8. Apply the web ui ingress of traefik
```
kubectl apply -f traefik-webui-ingress.yaml
```