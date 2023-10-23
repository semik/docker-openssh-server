# docker-openssh-server
Simple Alpine based Docker image for OpenSSH server

## build image

```
docker build -t sshd .
```

## local exec

```
export HOST_KEY=`cat example_ssh_host_rsa_key`
docker run -p 2022:2022 \
  -e AUTHORIZED_KEYS='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEigT76j7Ku8S5dhFRRFLD9tPO4x8VzyIOazMREi7Bq' \
  -e HOST_KEY="$HOST_KEY" sshd
```
