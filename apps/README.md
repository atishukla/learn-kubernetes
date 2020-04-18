# Namespaces exploration

- [x] Find out basic jenkins image with no initial password
- [x] Create 2 Jenkins instances in 2 namespaces
- [x] Access them with 2 instances

## some commands
kubectl exec web-0 -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'