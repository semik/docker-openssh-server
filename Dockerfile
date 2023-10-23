FROM alpine:3.18.4

RUN apk add --no-cache openssh-server

COPY content /
RUN addgroup --gid 10001 czertainly && \
    adduser --home /etc/ssh --uid 10001 --ingroup czertainly --disabled-password --shell /bin/sh czertainly && \
    sed -i "s/^.*PidFile.*$/PidFile \/dev\/null/" /etc/ssh/sshd_config && \
    sed -i "s/^.*PubkeyAuthentication.*$/PubkeyAuthentication yes/" /etc/ssh/sshd_config && \
    mkdir /etc/ssh/.ssh && \
    chown -R 10001:10001 /etc/ssh

USER 10001

EXPOSE 2022

CMD ["/entry.sh"]