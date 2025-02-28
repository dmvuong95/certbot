apk add curl bash > /dev/null \
  && certbot certonly \
      --server https://acme-v02.api.letsencrypt.org/directory \
      --preferred-challenges dns \
      -d "$domain_name" \
      -d "*.$domain_name" \
      --manual \
      --manual-auth-hook auth-hook.sh \
      --manual-cleanup-hook cleanup-hook.sh
