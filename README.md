## To deploy end to end on AWS cluster

#### Steps:1
1. Create the cluster using kops
2. Using one master t2.micro and one node t2.medium
```
kops create cluster --name=kubernetes.learn-devops.xyz --state=<URL OF S3 Bucket> --zones=eu-west-3a --node-count=1 --node-size=t2.medium --master-size=t2.micro --dns-zone=kubernetes.learn-devops.xyz
kops update cluster --name kubernetes.learn-devops.xyz --yes --state=<URL OF S3 Bucket>
```
3. It will take around 10 minutes to come up

## To deploy cluster on DO
```doctl kubernetes cluster create \
   --region fra1 \
   --tag kube \
   --size s-2vcpu-2gb \
   --count 1 \
   kube```

   doctl kubernetes cluster create \
   --region fra1 \
   --tag kube \
   --size s-2vcpu-4gb \
   --count 2 \
   kube
