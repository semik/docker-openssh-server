#!/bin/sh

SSH_KEY_FILE="/etc/ssh/ssh_host_rsa_key"

echo "Running under user:"
id

if [ "x$HOST_KEY" != "x" ]
then
    echo "HOST_KEY defined, overwriting $SSH_KEY_FILE*"
    lines=`echo "$HOST_KEY" | wc -l`
    echo "$HOST_KEY" > "$SSH_KEY_FILE"
    chmod 0600 "$SSH_KEY_FILE"
    ssh-keygen -f "$SSH_KEY_FILE" -y > "$SSH_KEY_FILE.pub"
fi

if [ "x$AUTHORIZED_KEYS"  != "x" ]
then
    echo "AUTHORIZED_KEYS provided"
    echo "$AUTHORIZED_KEYS" > /home/czertainly/.ssh/authorized_keys
fi

if ! ls -1 /etc/ssh/ |grep '^ssh_host.*key$' > /dev/null
then
    echo "Missing SSH Host Key, creating:"
    ssh-keygen -A
fi

echo "Executitng OpenSSH"
/usr/sbin/sshd -p 2022 -D -e $SSHD_ARGS