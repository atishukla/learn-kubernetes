### To apply network policy on kubernetes using CNI provider like Calico

Theory:
- Strict minimum access should be applicable.
- Pods should have access to only the resources they want to work effectively.
- For ex frontend - connects to backend - and it connects to db it should not connect.

Usecase:
- In Dev cluster the pod should not be able to connect to the prod database.
- You isolate teams based on ns and you dont want any interconnection between them.

Scope:
- Kubernetes define the process of networking but the implementation is based on third party plugins like calico.

Tests:
- Step 1  Create a development namespace ```kubectl apply -f admin/network-policy/01-namespace.yaml```
- Step 2 ```kubectl run backend --image=nginx --labels app=webapp,role=backend --namespace development --expose --port 80 --generator=run-pod/v1```
or
- Step 3 ```kubectl apply -f admin/network-policy/02-pod-svc-nginx-backend.yaml```
This will create a Pod and a svc in the backend
```
atishay@atishay:~/projects/learn-kubernetes$ kubectl -n development get po
NAME      READY   STATUS    RESTARTS   AGE
backend   1/1     Running   0          16s
atishay@atishay:~/projects/learn-kubernetes$ kubectl -n development get svc
NAME      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
backend   ClusterIP   10.245.216.248   <none>        80/TCP    19s
atishay@atishay:~/projects/learn-kubernetes$ 
```
- Step 4: We run a multi tool pod in the development namespace in the interactive mode to test the connectivity
```
kubectl run --rm -it nwtool --image praqma/network-multitool -n development --generator=run-pod/v1
```
For some reason the above does not work.
Tried this
```kubectl run nwtool --image praqma/network-multitool -n development --generator=run-pod/v1```
```kubectl -n development exec -it nwtool /bin/bash```

If I try nslookup I get response.

```
bash-5.0# nslookup backend
Server:         10.245.0.10
Address:        10.245.0.10#53

Name:   backend.development.svc.cluster.local
Address: 10.245.216.248
```

also curl backend works and bring nginx page

```
bash-5.0# curl backend
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

### Scenario to restrict now.

- We create a policy to deny all, the label will include backend, here nginx is using that label
```
kubectl apply -f admin/network-policy/03-deny-all.yaml

atishay@atishay:~/projects/learn-kubernetes$ kubectl get NetworkPolicy -A
NAMESPACE     NAME             POD-SELECTOR              AGE
development   backend-policy   app=webapp,role=backend   81s
atishay@atishay:~/projects/learn-kubernetes$ 
```

- Now lets exec again to nwtool pod and we see the connection timeouts
```
kubectl -n development exec -it nwtool /bin/bash

bash-5.0# curl --connect-timeout 5 backend
curl: (28) Connection timed out after 5002 milliseconds
bash-5.0# 
```

### Scenario to allow some pods now.

Here we will apply a network policy which will allow the pod with specific labels.
See the ingress there for the same.

```
kubectl apply -f admin/network-policy/04-allow-all.yaml

atishay@atishay:~/projects/learn-kubernetes$ kubectl apply -f admin/network-policy/04-allow-all.yaml
networkpolicy.networking.k8s.io/backend-policy configured
```

Now lets make the same test (Note we have not updated the labels in nwtool pod which is role frontend)

```
bash-5.0# curl --connect-timeout 5 backend
curl: (28) Connection timed out after 5001 milliseconds
bash-5.0# 
```
So we see we dont have connectivity

Now lets update the correct label to the pod

```
kubectl -n development describe pod nwtool | grep  -i labels

Labels:       run=nwtool

kubectl -n development label pods nwtool app=webapp role=frontend

atishay@atishay:~/projects/learn-kubernetes$ kubectl -n development describe pod nwtool | grep  -i labels -A 3
Labels:       app=webapp
              role=frontend
              run=nwtool
Annotations:  <none>
```

Now we try again to curl backend and it works

```
bash-5.0# curl backend
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

### Scenario to allow pods with labels as well as same namespace.

- This will be more restrictive
- Same namespace and it should have some labels
- Here we will not use namespace but we will use labels for namespace selector as well
- See the file 01-namespace.yaml that we have already labelled it as purpose development
- For this demo lets create another namespace

```
kubectl create ns production
kubectl label namespace/production purpose=production
```

We kill and create the nwtool pod in production namespace
```
kubectl run nwtool --image praqma/network-multitool -n production --labels app=webapp,role=frontend --generator=run-pod/v1


atishay@atishay:~/projects/learn-kubernetes$ kubectl -n production get po
NAME     READY   STATUS    RESTARTS   AGE
nwtool   1/1     Running   0          10s

kubectl -n production exec -it nwtool /bin/bash

```

Now we curl backend and see it works

But now we will have to give the namespace of the svc as well

```
bash-5.0# curl backend.development
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

Thats cool

Now apply the new policy

```
kubectl apply -f admin/network-policy/05-allow-all-namespace-selector.yaml
```

Now run curl

```
bash-5.0# curl --connect-timeout 5 backend.development
curl: (28) Connection timed out after 5001 milliseconds
```

- Now lets try with the container in the same namespace
```
kubectl run nwtool --image praqma/network-multitool -n development --labels app=webapp,role=frontend --generator=run-pod/v1

kubectl -n development exec -it nwtool /bin/bash
```

It works now

```
bash-5.0# curl backend.development
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```



