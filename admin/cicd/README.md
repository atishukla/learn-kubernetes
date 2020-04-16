It’s generally not recommended to use the default admin user to authenticate from other Services into your Kubernetes cluster. If your keys on the external provider got compromised, your whole cluster would become compromised.

Instead you are going to use a single Service Account with a specific Role, which is all part of the RBAC Kubernetes authorization model.

This authorization model is based on Roles and Resources. You start by creating a Service Account, which is basically a user on your cluster, then you create a Role, in which you specify what resources it has access to on your cluster. Finally, you create a Role Binding, which is used to make the connection between the Role and the Service Account previously created, granting to the Service Account access to all resources the Role has access to.

1. ```kubectl apply -f 01-cicd-service-account.yml```
2. Try Service account works
```TOKEN=$(kubectl get secret $(kubectl get secret | grep cicd-token | awk '{print $1}') -o jsonpath='{.data.token}' | base64 --decode)```
3. Get the kubernetes url from vim ~/.kube/config. It would be something like https://xxx-xxxx-xxxx-xxxx-xxxxxxx.k8s.ondigitalocean.com/
4. Substitute this in the below command to test the service account.
5. Try to get the pod using cicd service accounts
```kubectl --insecure-skip-tls-verify --kubeconfig="/dev/null" --server=server-from-kubeconfig-file --token=$TOKEN get pods```
6. Verify you get output like this
```
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:default:cicd" cannot list resource "pods" in API group "" in the namespace
 "default"
```
This makes the service account works but the correct authorization is not present but the token itself works
7. Kubernetes has two ways to define roles: using a Role or a ClusterRole resource. The difference between the former and the latter is that the first one applies to a single namespace, while the other is valid for the whole cluster.
8. We will use Role here as we are only working on default namespace see 02-cicd-role.yml
9. Role itself cannot do anything we will create rolebinding.
10. Now re run the command in step 5 and you will see below.
```
No resources found in default namespace.
```
It is because we dont have any pods in default namespace