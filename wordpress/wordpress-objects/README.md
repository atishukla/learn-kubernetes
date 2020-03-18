### Setup Instructions

1. create pvc for wordpress
```
kubectl apply -f wordpress-pvc.yaml
```
2. Use environment file for secrets
```
./create-wordpress-credentials.sh
```
3. Apply the deployment
```
kubectl apply -f wordpress-deployment.yaml
```
4. Now we transfer the data which we backed up
```
kubectl cp wordpress-data.tar.gz testblog-699d4fbb4d-jrdzj:/tmp/
```
5. untar the back up from /tmp and move to workdir /var/www/html
```
tar xzf wordpress-data.tar.gz -C /var/www/html/
```
6. change the ownership to 33
```
chown 33:33 * -R
```
Get error 500
7. Restart container