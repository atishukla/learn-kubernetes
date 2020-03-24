### To see the change in Docker image once push to registry

- Result - it overwrites everything till registry

## When you have different dockerfile
```docker build -t ruby:v3 -f Dockerfile.v2 .```
Notice . in the last is important as with Dockerfile it gives preference to it.