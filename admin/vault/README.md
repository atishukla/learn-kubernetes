### Why keyvault

- Just to have the secrets in vault.
- No one person has the access to secret.
- It can be dynamically rotated but that is not yet included here.


- In traditional world we create secret and then supply to kubernetes.
- Human is involved in creating the secret which poses as a risk.
- Also the kubernetes secret is not secure or encrypted at rest.
- At the max it is base64 encoded but it is too in efficient.
- Here we run pods as a service account which we can trust. Therefore no manual intervention needed for any person.

### Flow

- Pod runs as a service account.
- It authenticates to Vault using the service account.
- Vault does verification with the kubernetes api to  see if its valid.
- generate and fetch temporary credentials from the database.
- Then it creates the scret and mounts it to the pod automatically.
- If the pod dies then vault will clean it up automatically at the database.


### Installation

```
Client Version: v1.17.4
Server Version: v1.17.5
```

- There are 2 components to vault. One is SERVER and other is INJECTOR
 #### Vault modes
- Dev Mode
- Standalone mode
. It has single vault cluster running
. By default the vault is sealed and the vault does not have the key to unseal
. 
- HA mode

- Storage is also very important for Vault

Vault while starting generate 5 keys .

Vault needs 3 keys out of 5 to to unseal
We have to distribute the keys and it does not stay in the cluster

### kubernetes installation

So we will run everything in the folder under vault server
We will also need to setup the TLS certificate for the vault and give it appropriate CN name.
For that see the video
Currently I have just copied it in the secret
```
kubectl create ns vault-example
kubectl -n vault-example apply -f admin/vault/server/
```

The vault cluster is unsealed and the readiness probe will be killing it till we unseal it
```
kubectl -n vault-example exec -it vault-example-0 vault operator init
```
Make notes of the keys and token that is very important
```
kubectl -n vault-example exec -it vault-example-0 vault operator unseal
```
Repeat the above command with 3 keys out of 5
Check the pod again and now it will be running


### Vaults commands

```
kubectl -n vault-example exec -it vault-example-0 sh
vault operator key-status
This should redirect to https
Error reading key status: Error making API request.

URL: GET https://127.0.0.1:8200/v1/sys/key-status
Code: 400. Errors:

* missing client token
```

We will try to login to vault server

```
vault login
Give the token in the first init
This is one time action
```

## Vault injector

After server runs we will cover basic functinality which is defining the secret in vault cluster and moving to our pod.

- For this we need vault injector.
Its important that we have api for admission controllers present in the cluster as it uses webhooks for this purpose
- Check it using 
```
kubectl api-versions
Output:
admissionregistration.k8s.io/v1
admissionregistration.k8s.io/v1beta1
```

- The resources for it is in injector folder.

- We create a service account so that it can authenticate the vault with kube server api
```
kubectl -n vault-example apply -f admin/vault/injector/
```
- It will deploy the injector pod in the vault-example ns

- Now we have do kubernetes-auth configuration in vault container


### Injector Kubernetes Auth Policy
```
kubectl -n vault-example exec -it vault-example-0 vault login
kubectl -n vault-example exec -it vault-example-0 vault auth enable kubernetes
Output:
Success! Enabled kubernetes auth method at: kubernetes/

kubectl -n vault-example exec -it vault-example-0 sh
vault write auth/kubernetes/config \
token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
exit

kubectl -n vault-example get pods
```

### Basic Secret Injection

```
#Create a role for our app

kubectl -n vault-example exec -it vault-example-0 sh 

vault write auth/kubernetes/role/basic-secret-role \
   bound_service_account_names=basic-secret \
   bound_service_account_namespaces=vault-example \
   policies=basic-secret-policy \
   ttl=1h
```
The above maps our Kubernetes service account, used by our pod, to a policy. Now lets create the policy to map our service account to a bunch of secrets

```
kubectl -n vault-example exec -it vault-example-0 sh
cat <<EOF > /home/vault/app-policy.hcl
path "secret/basic-secret/*" {
  capabilities = ["read"]
}
EOF
vault policy write basic-secret-policy /home/vault/app-policy.hcl
exit
```
Now our service account for our pod can access all secrets under secret/basic-secret/* Lets create some secrets.
```
kubectl -n vault-example exec -it vault-example-0 sh 
vault secrets enable -path=secret/ kv
vault kv put secret/basic-secret/helloworld username=dbuser password=sUp3rS3cUr3P@ssw0rd
exit
```

Now that we have created a secret we will use a sample application to demo it

- TODO: I cannot use postgres for now as I have to see how to use various plugins to create a connection string for the db

```
kubectl -n vault-example apply -f ./hashicorp/vault/example-apps/basic-secret/deployment.yaml
```

Verify if it has secret

```
kubectl -n vault-example exec -it basic-secret-74b4fdbcdc-zhzr2 sh
/app # cat /vault/secrets/helloworld 
{
  "username" : "dbuser",
  "password" : "sUp3rS3cUr3P@ssw0rd"
}
/app # 
```