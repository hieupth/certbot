#!/bin/sh
set -e
exec "$@"
# Save decrypt password.
echo "$CERTBOT_ENCRYPTION_PASSWORD" > /password
# Pull certs git repo if exist.
if [[ -z "${CERTBOT_SSL_REPO}" ]] 
then
  echo "Ignore git"
else
  echo "Git clone: ${CERTBOT_SSL_REPO}"
  if cd /ssl 
  then 
    git fetch
    git reset --hard origin/main 
  else 
    cd /
    git clone ${CERTBOT_SSL_REPO} /ssl 
  fi
fi  
# Ansible decrypt certs.
ansible-vault decrypt --vault-password-file /password \
  /ssl/certs/${CERTBOT_DOMAINS}/fullchain.pem \
  /ssl/certs/${CERTBOT_DOMAINS}/privkey.pem \
  /ssl/certs/${CERTBOT_DOMAINS}/cert.pem \
  /ssl/certs/${CERTBOT_DOMAINS}/chain.pem \
  /ssl/certs/${CERTBOT_DOMAINS}/concat.pem 
# Fix certs permission.
chmod 600 /ssl/certs/${CERTBOT_DOMAINS}/*.pem