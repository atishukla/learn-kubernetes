### MYSQL
1. Step 1: Create mysql.env with username and password like: MYSQL_ROOT_PASSWORD=toughpassword
2. Step 2: Create secret with this env variable using the script create-mysql-credentials.sh
3. Step 3: Run the stateful set
```
kubectl apply -f mysql-statefulset.yaml
```
4. Step 4: Login to database container to create local database
```
kubectl exec -it mysql-0 bash
```
5. Step 5: Create Database
```
mysql -u root -p
```
6. Step 6: Create databases
```
show databases;
```
7. Step 7: You can create a backup of database
```
mysqldump db_testblog_demo_atishay_com > db_testing.dump
gzip -9 db_testing.dump
```
8. Step 8: You can connect the database
```
kubectl port-forward svc/mysql 3306:3306
```
9. Step 9: Create database in mysql by exec in the container and running following commands login as mysql root user
```
create database wordpress;
grant all on wordpress.* to 'wordpress'@'%' identified by 'strongpassword';
flush privileges;
select user,host,authentication_string from mysql.user;
```
10. Step 10: restore database
```
kubectl exec mysql-0 -- bash -c 'MYSQL_PWD=strongpassword' -- mysql -u wordpress wordpress < db_wordpress.dump
```
11. For some reason above command does not populate the tables
I had to download mysql client on the machine and do port forwarding to copy the data
```
kubectl port-forward svc/mysql 3306:3306
mysql -h 127.0.0.1 -u wordpress -D wordpress -p < db_wordpress.dump
```

