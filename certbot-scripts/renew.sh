apk add curl bash > /dev/null \
  && certbot renew \
      --cert-name $domain_name \
      --preferred-challenges dns \
      --manual \
      --manual-auth-hook auth-hook.sh \
      --manual-cleanup-hook cleanup-hook.sh
