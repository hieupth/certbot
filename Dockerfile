FROM python:3-alpine

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
ENV DEBUG=false
ENV SEPARATE=false

RUN apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev && \
    apk add --no-cache libffi-dev openssl-dev dialog && \
    pip install --no-cache-dir certbot cryptography certbot-dns-cloudflare && \
    apk del .build-deps

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]