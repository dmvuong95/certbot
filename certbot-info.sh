#!/bin/bash
set -e
dir_name=$(dirname $0)

cd $dir_name

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
           certbot/certbot \
           certificates
