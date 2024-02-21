# mysql backup image
FROM alpine:3.19.1
LABEL org.opencontainers.image.authors="https://github.com/halkeye"

RUN apk add --no-cache --update postgresql-client postgresql15-client postgresql16-client bash python3 samba-client shadow openssl coreutils aws-cli && \
    touch /etc/samba/smb.conf

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
