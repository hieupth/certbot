#!/bin/sh

get_certificate() {
  local d=${domain//,*/}
  echo "Getting certificate for $domain"
  certbot certonly --agree-tos --renew-by-default -n \
    --text --server https://acme-v02.api.letsencrypt.org/directory \
    --email $EMAIL -d $domain $args
  # ec=$?
  # echo "certbot exit code $ec"
  local d=$(echo $d | sed 's/^*.//')
  # Concat the full chain with the private key (e.g. for haproxy)
  cat /etc/letsencrypt/live/$d/fullchain.pem /etc/letsencrypt/live/$d/privkey.pem > /etc/letsencrypt/live/$d/concat.pem
  # Keep full chain and private key in separate files (e.g. for nginx and apache)
  mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/fullchain.pem /certs/$d/fullchain.pem
  mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/privkey.pem /certs/$d/privkey.pem
  mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/cert.pem /certs/$d/cert.pem
  mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/chain.pem /certs/$d/chain.pem
  mkdir -p /certs/$d/ && cp /etc/letsencrypt/live/$d/concat.pem /certs/$d/concat.pem
  # Encrypt all certs.
  if ! [[ -z "$ENCRYPT_PASS_FILE" ]]; then
    ansible-vault encrypt --vault-password-file $ENCRYPT_PASS_FILE \
      /certs/$d/fullchain.pem \
      /certs/$d/privkey.pem \
      /certs/$d/cert.pem \
      /certs/$d/chain.pem \
      /certs/$d/concat.pem
  fi
}

# Build arguments for certbot command.
args=""
# Debug only,
if [ "$DEBUG" = true ]; then
  echo "Debug mode...";
  args=$args" --debug --dry-run";
# Obtain with plugins.
else
  if ! [[ -z $CLOUDFLARE_TOKEN_FILE ]]; then
    args="--dns-cloudflare --dns-cloudflare-credentials $CLOUDFLARE_TOKEN_FILE --dns-cloudflare-propagation-seconds $PROPAGATION"
  elif ! [[ -z $WEBROOT ]]; then
    args="--webroot -w $WEBROOT"
  else
    args="--standalone --preferred-challenges http-01"
  fi
fi

# Seperate domains and obtain certs.
for domain in ${DOMAINS//|/ } ; do 
  echo "Running certbot for domain $domain"
  get_certificate
done