#!/bin/sh

get_certificate() {
  local d=${domain//,*/}
  echo "Getting certificate for $domain"
  certbot certonly --agree-tos --renew-by-default -n \
    --text --server https://acme-v02.api.letsencrypt.org/directory \
    --email $EMAIL -d $domain $args
  ec=$?
  echo "certbot exit code $ec"
  if [ $ec -eq 0 ]
  then
    if [ $CONCAT = true ]; then
      # Concat the full chain with the private key (e.g. for haproxy)
      mkdir -p /certs/$d/ && cat /etc/letsencrypt/live/$d/fullchain.pem /etc/letsencrypt/live/$d/privkey.pem > /certs/$d/concat.pem
    fi
    # Keep full chain and private key in separate files (e.g. for nginx and apache)
    mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/fullchain.pem /certs/$d/fullchain.pem
    mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/privkey.pem /certs/$d/private.pem
    mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/cert.pem /certs/$d/cert.pem
    mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/chain.pem /certs/$d/chain.pem
    echo "Certificate obtained for $domain! Your new certificate - named $d - is in /certs"
  else
    echo "Cerbot failed for $domain. Check the logs for details."
  fi
}

# Build arguments for certbot command.
args=""
# Webroot mode.
if ! [[ -z $WEBROOT ]]; then
  echo "Using webroot: $WEBROOT"
  args="--webroot -w $WEBROOT"
# Cloudflare mode.
elif [[ -f $CLOUDFLARE_TOKEN_FILE ]]; then
  echo "Using Cloudflare..."
  args="--dns-cloudflare --dns-cloudflare-credentials $CLOUDFLARE_TOKEN_FILE --dns-cloudflare-propagation-seconds 60"
# Otherwise, use standalone mode.
else
  echo "Using standalone..."
  args="--standalone --preferred-challenges http-01"
fi

# Enable debug (dry-run) mode.
if [ "$DEBUG" = true ]
then
  echo "Debug mode..."
  args=$args" --debug --dry-run"
fi

# Seperate domains and obtain certs.
for domain in ${DOMAINS//;/ } ; do 
  echo "Running certbot for domain $domain"
  get_certificate
done