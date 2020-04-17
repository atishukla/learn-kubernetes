### Keep resources for databases

Ideally the resources for databases would be managed by someone else and it will be different from the application

- get random password for database
```head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''```

- create manually the secret from shell script

- deploy the stateful set for postgres