# Helm Chart for basic HTTP server

This repository is mainly my **Docker**|**Helm**|**Kubernetes** learning project.

It implements simple HTTP server with SSH server for uploading content. HTTP server is using official nginx image. SSH server is using my own Docker image.

## SSH key generation

In case you what to use server on ReadOnly FileSystem you need to prepare SSH key:
```
ssh-keygen -q -N "" -t rsa -b 2048 -f local/rsa_key
```
that command will create new SSH RSA key and store it in file `local/rsa_key` corresponding public key will be stored in `local/rsa_key.pub`.

To be able to log in into SSH server you have to provide `local/authorized_keys`.


## OpenSSH Server docker image

Simple Alpine-based Docker image for OpenSSH server with added user.

It runs under user *czertainy* `uid=10001`. And exposes port 2022. The image is prepared to run on a RO filesystem.

### build image

```
docker build -t sshd .
```

## local exec

```
export HOST_KEY=`cat example_ssh_host_rsa_key`
docker run -p 2022:2022 \
  -e AUTHORIZED_KEYS='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEigT76j7Ku8S5dhFRRFLD9tPO4x8VzyIOazMREi7Bq' \
  -e SSHD_ARGS="-d" \
  -e HOST_KEY="$HOST_KEY" sshd
```

### why another sshd image?

Well many of them are outdated and/or not updated often.

[linuxserver/openssh-server](https://hub.docker.com/r/linuxserver/openssh-server) looks like one well managed. But it is not possible to run it without root:
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

### errors

#### `Attempt to write login records by non-root user (aborting)`

When running under non-root, it produces above warning line in logs peer every user login. This is fine, it is produced by [`login_write()`](https://github.com/openssh/openssh-portable/blob/master/loginrec.c#L440) which tries to write into `/var/log/lastlog` and this is possible only as root.
