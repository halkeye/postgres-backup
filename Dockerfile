# mysql backup image
FROM alpine:3.17
LABEL org.opencontainers.image.authors="https://github.com/halkeye"

RUN apk add --no-cache --update postgresql-client postgresql15-client bash python3 py3-pip samba-client shadow openssl coreutils && \
    touch /etc/samba/smb.conf && \
    pip3 install awscli

# set us up to run as non-root user
RUN groupadd -g 1005 appuser && \
    useradd -r -u 1005 -g appuser appuser
# ensure smb stuff works correctly
RUN mkdir -p /var/cache/samba && \
        chmod 0755 /var/cache/samba && \
        chown appuser /var/cache/samba && \
        chown appuser /var/lib/samba/private && \
        mkdir -p backup && \
        chown appuser /backup
USER appuser

# install the entrypoint
COPY functions.sh /
COPY entrypoint /entrypoint

# start
ENTRYPOINT ["/entrypoint"]
