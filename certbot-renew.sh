#!/bin/bash
set -e

# echo iso date
echo "[DATE] $(date --iso-8601=seconds)"
dir_name=$(dirname $0)

cd $dir_name

# Read .env file
export $(grep -v '^#' .env | xargs)

get_perms() {
  cp -rL /etc/letsencrypt/live/$DOMAIN/* ./perms/
  chmod 400 ./perms/privkey.pem
}

get_perms
# Get SHA-256 hash of file ./perms/fullchain.pem
prev_hash=$(openssl x509 -in ./perms/fullchain.pem -noout -sha256 -fingerprint)

docker run --rm \
           -e "CLOUDFLARE_API_KEY=$CLOUDFLARE_API_KEY" \
           -e "CLOUDFLARE_EMAIL=$CLOUDFLARE_EMAIL" \
           -e "domain_name=$DOMAIN" \
           -v "/etc/letsencrypt:/etc/letsencrypt" \
           -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
           -v "/var/log:/var/log" \
           -v "./certbot-scripts:/certbot-scripts" \
           -w /certbot-scripts \
           --entrypoint /bin/sh \
           certbot/certbot \
           renew.sh

get_perms
# Get SHA-256 hash of file ./perms/fullchain.pem
new_hash=$(openssl x509 -in ./perms/fullchain.pem -noout -sha256 -fingerprint)

# Compare the two hashes
if [ "$prev_hash" != "$new_hash" ]; then
  bash ./hook.sh
else
  echo "Certificate not renewed."
fi

echo "Done at $(date --iso-8601=seconds)"
echo "----------------------------------------"
