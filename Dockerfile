FROM python:3-alpine

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
ENV DEBUG=false
ENV CONCAT=false
ENV SEPARATE=false

RUN apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev && \
    apk add --no-cache libffi-dev openssl-dev dialog dcron && \
    pip install --no-cache-dir certbot && \
    apk del .build-deps && \
    mkdir /scripts && \
    pip install --no-cache-dir certbot-dns-cloudflare

COPY ./scripts/ /scripts
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]