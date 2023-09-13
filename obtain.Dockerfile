FROM python:3-alpine
LABEL maintainer="hieupth <64821726+hieupth@users.noreply.github.com>"

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
ENV CERTBOT_DEBUG=false
ENV CERTBOT_SEPARATE=false

RUN apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev && \
    apk add --no-cache libffi-dev openssl-dev dialog && \
    pip install --no-cache-dir certbot cryptography certbot-dns-cloudflare ansible-vault && \
    apk del .build-deps

COPY obtain.sh /usr/local/bin/obtain-ssl.sh
RUN chmod +x /usr/local/bin/obtain-ssl.sh

ENTRYPOINT ["/usr/local/bin/obtain-ssl.sh"]