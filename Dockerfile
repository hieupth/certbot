FROM python:3-alpine

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
ENV CERTBOT_DEBUG=false
ENV CERTBOT_SEPARATE=false

RUN apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev && \
    apk add --no-cache libffi-dev openssl-dev dialog && \
    pip install --no-cache-dir certbot cryptography certbot-dns-cloudflare && \
    apk del .build-deps