#!/bin/sh

get_certificate() {
  local d=${domain//,*/}
  echo "Getting certificate for $domain"
  certbot certonly --agree-tos --renew-by-default -n \
    --text --server https://acme-v02.api.letsencrypt.org/directory \
    --email $EMAIL -d $domain $args
  # ec=$?
  # echo "certbot exit code $ec"
}

# Build arguments for certbot command.
args=""
# Select DNS plugins.
if ! [[ -z $WEBROOT ]]; then
  echo "Using webroot: $WEBROOT"
  args="--webroot -w $WEBROOT"
elif ! [[ -z $CLOUDFLARE_TOKEN_FILE ]]; then
  echo "Using Cloudflare DNS..."
  args="--dns-cloudflare --dns-cloudflare-credentials $CLOUDFLARE_TOKEN_FILE --dns-cloudflare-propagation-seconds $PROPAGATION"
# Use standalone if none of them is selected.
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
for domain in ${DOMAINS//|/ } ; do 
  echo "Running certbot for domain $domain"
  get_certificate
done