#!/bin/bash
set -e

# Read .env file
export $(grep -v '^#' .env | xargs)

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
           register.sh

cp -rL /etc/letsencrypt/live/$DOMAIN/* ./perms/
chmod 400 ./perms/privkey.pem
# Execute the hook script
bash ./hook.sh
