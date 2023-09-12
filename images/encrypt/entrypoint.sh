#!/bin/sh

echo "Running certbot for domains $DOMAINS"

get_certificate() {
    # Gets the certificate for the domain(s) CERT_DOMAINS (a comma separated list)
    # The certificate will be named after the first domain in the list
    # To work, the following variables must be set:
    # - CERT_DOMAINS : comma separated list of domains
    # - EMAIL
    # - CONCAT
    # - args
    local d=${CERT_DOMAINS//,*/} # read first domain
    echo "Getting certificate for $CERT_DOMAINS"
    certbot certonly --agree-tos --renew-by-default -n \
    --text --server https://acme-v02.api.letsencrypt.org/directory \
    --email $EMAIL -d $CERT_DOMAINS $args
    ec=$?
    echo "certbot exit code $ec"
    local d=$(echo $d | sed 's/^*.//')
    if [ $ec -eq 0 ]
    then
        # concat the full chain with the private key (e.g. for haproxy)
        cat /etc/letsencrypt/live/$d/fullchain.pem /etc/letsencrypt/live/$d/privkey.pem > /etc/letsencrypt/live/$d/concat.pem
        # keep full chain and private key in separate files (e.g. for nginx and apache)
        mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/fullchain.pem /certs/$d/fullchain.pem
        mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/privkey.pem /certs/$d/privkey.pem
        mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/cert.pem /certs/$d/cert.pem
        mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/chain.pem /certs/$d/chain.pem
        mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/concat.pem /certs/$d/concat.pem
        # encrypt all files.
        ansible-vault encrypt --vault-password-file password \
            /certs/$d/fullchain.pem \
            /certs/$d/privkey.pem \
            /certs/$d/cert.pem \
            /certs/$d/chain.pem \
            /certs/$d/concat.pem
        echo "Certificate obtained for $CERT_DOMAINS! Your new certificate - named $d - is in /etc/letsencrypt/live/$d"
    else
        echo "Cerbot failed for $CERT_DOMAINS. Check the logs for details."
    fi
}
# Save encrypt password.
echo "$PASSWORD" > password
# Build arguments string for certbot command.
args=""
# Webroot mode.
if ! [[ -z $WEBROOT ]]; then
    args="--webroot -w $WEBROOT"
# Cloudflare mode.
elif ! [[ -z $CLOUDFLARE ]]; then
    echo "dns_cloudflare_api_token = $CLOUDFLARE" > cloudflare.ini
    chmod 600 cloudflare.ini
    args="--dns-cloudflare --dns-cloudflare-credentials cloudflare.ini --dns-cloudflare-propagation-seconds 60"
# Otherwise, use standalone mode.
else
    args="--standalone --preferred-challenges http-01"
fi
# Enable debug (dry-run) mode.
if [ $DEBUG = true ]
then
    args=$args" --debug --dry-run"
fi
# In case of SEPARATE is TRUE,
# Domains will be separated and certificates will be generated for each of them.
if [ $SEPARATE = true ]
then
    for d in $DOMAINS
    do
        CERT_DOMAINS=$d
        get_certificate
    done
# Otherwise,
# One certificate for all domains will be generated.
else
    CERT_DOMAINS=${DOMAINS// /,}
    get_certificate
fi