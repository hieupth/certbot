FROM python:3-alpine
LABEL maintainer="hieupth <64821726+hieupth@users.noreply.github.com>"

RUN apk update && \
    apk upgrade && \
    apk add --update git && \
    apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev && \
    apk add --no-cache libffi-dev && \
    pip install --no-cache-dir ansible-vault && \
    apk del .build-deps

COPY gitfetch.sh /usr/local/bin/gitfetch.sh
RUN chmod +x /usr/local/bin/gitfetch.sh

ENTRYPOINT [ "/usr/local/bin/fetch-ssl.sh" ]