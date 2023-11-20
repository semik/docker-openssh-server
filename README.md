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

## why another sshd image?

Well many of them are outdated and/or not updated often. 

[linuxserver/openssh-server](https://hub.docker.com/r/linuxserver/openssh-server) looks like only one well managed. But it is not possible to run it without root:
```
root@71db271c45e5:/# ps aux 
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0    208    72 ?        Ss   08:15   0:00 /package/admin/s6/command/s6-svscan -d4 -- /run/service
root          15  0.0  0.0    212    68 ?        S    08:15   0:00 s6-supervise s6-linux-init-shutdownd
root          17  0.0  0.0    200     4 ?        Ss   08:15   0:00 /package/admin/s6-linux-init/command/s6-linux-init-shutdownd -c /run/s6/basedir -
root          38  0.0  0.0    212    60 ?        S    08:15   0:00 s6-supervise svc-openssh-server
root          39  0.0  0.0    212    64 ?        S    08:15   0:00 s6-supervise s6rc-fdholder
root          40  0.0  0.0    212    64 ?        S    08:15   0:00 s6-supervise s6rc-oneshot-runner
root          41  0.0  0.0    212    64 ?        S    08:15   0:00 s6-supervise log-openssh-server
root          52  0.0  0.0    524   160 ?        Ss   08:15   0:00 /package/admin/s6-2.11.3.2/command/s6-fdholderd -1 -i data/rules
root          53  0.0  0.0    188     4 ?        Ss   08:15   0:00 /package/admin/s6/command/s6-ipcserverd -1 -- /package/admin/s6/command/s6-ipcser
linuxse+     176  0.0  0.0    272     4 ?        Ss   08:15   0:00 s6-log n30 s10000000 S30000000 T !gzip -nq9 /config/logs/openssh
linuxse+     180  0.0  0.0   6560  4664 ?        Ss   08:15   0:00 sshd.pam: /usr/sbin/sshd.pam -D -e [listener] 0 of 10-100 startups
root         210  0.0  0.0   1672   992 pts/0    Ss   08:15   0:00 sh
root         239  0.0  0.0   2464  1688 pts/0    R+   08:21   0:00 ps aux
```

And I also need posibility to provide image with my SSH Host Key to prevent warning on client side.
