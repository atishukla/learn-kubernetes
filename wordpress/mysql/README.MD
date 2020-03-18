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

