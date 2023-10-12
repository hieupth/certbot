#!/bin/sh
set -e
exec "$@"

get_certificate() {
  # Gets the certificate for the domain(s) CERT_DOMAINS (a comma separated list)
  # The certificate will be named after the first domain in the list
  # To work, the following variables must be set:
  # - CERT_DOMAINS : comma separated list of domains
  # - EMAIL
  # - CONCAT
  # - args
  local d=${CERT_DOMAINS//,*/} # read first domain
  # Ansible decrypt certs.
  if ! [[ -z "$CERTBOT_ENCRYPT_PASS_FILE" ]]
  then
    echo "Decrypt $d"
    ansible-vault decrypt --vault-password-file $CERTBOT_ENCRYPT_PASS_FILE \
      /ssl/certs/$d/fullchain.pem \
      /ssl/certs/$d/privkey.pem \
      /ssl/certs/$d/cert.pem \
      /ssl/certs/$d/chain.pem \
      /ssl/certs/$d/concat.pem 
    # Fix certs permission.
    chmod 600 /ssl/certs/$d/*.pem
  fi
}

# Make encrytion password file for ansible-vault.
if ! [[ -z $CERTBOT_ENCRYPT_PASS_FILE ]]
then
    echo "Certs encryption is enabled"
else
    echo "Certs encryption is disabled"
fi

# Pull certs git repo if exist.
if [[ -z "${CERTBOT_SSL_GIT_REMOTE}" ]] 
then
  echo "Ignore git"
else
  echo "Git clone: ${CERTBOT_SSL_GIT_REMOTE}"
  if cd /ssl 
  then 
    git fetch
    git reset --hard origin/main 
  else 
    cd /
    git clone ${CERTBOT_SSL_GIT_REMOTE} /ssl 
  fi
  if ! [[ -z $CERTBOT_SSL_GIT_COMMIT ]]
  then
    cd /ssl
    git checkout $CERTBOT_SSL_GIT_COMMIT
  fi
fi

for d in $CERTBOT_DOMAIN
do
  CERT_DOMAINS=$d
  get_certificate
done