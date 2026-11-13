#!/usr/bin/env bash
# Publica o portfólio no nginx desta VPS. Roda como root, depois de enviar /tmp/site.tar.gz.
# Só cria o vhost do domínio abaixo; não mexe nos outros sites do servidor.
# Para atualizar o site depois: envie um novo /tmp/site.tar.gz e rode de novo.
set -euo pipefail

DOMINIO="jhonatan-camargo.natela.tech"
RAIZ="/var/www/jhonatan-camargo"
VHOST="/etc/nginx/sites-available/jhonatan-camargo"
CERT="/etc/letsencrypt/live/$DOMINIO"

[ -f /tmp/site.tar.gz ] || { echo "ERRO: /tmp/site.tar.gz não encontrado (rode o scp antes)"; exit 1; }

mkdir -p "$RAIZ"
tar -xzf /tmp/site.tar.gz -C "$RAIZ"
chown -R www-data:www-data "$RAIZ"

vhost() { # $1 = "http" ou "https"
  {
    echo "server {"
    echo "    listen 80;"
    echo "    listen [::]:80;"
    echo "    server_name $DOMINIO;"
    echo "    location ^~ /.well-known/acme-challenge/ { root $RAIZ; }"
    if [ "$1" = https ]; then
      echo "    location / { return 301 https://\$host\$request_uri; }"
      echo "}"
      echo "server {"
      echo "    listen 443 ssl;"
      echo "    listen [::]:443 ssl;"
      echo "    server_name $DOMINIO;"
      echo "    ssl_certificate $CERT/fullchain.pem;"
      echo "    ssl_certificate_key $CERT/privkey.pem;"
    fi
    echo "    root $RAIZ;"
    echo "    index index.html;"
    echo "    location / { try_files \$uri \$uri/ =404; }"
    echo "    location /assets/ { expires 30d; add_header Cache-Control \"public\"; }"
    echo "}"
  } > "$VHOST"
  ln -sf "$VHOST" /etc/nginx/sites-enabled/jhonatan-camargo
  nginx -t
  systemctl reload nginx
}

# Certificado pelo método webroot, o mesmo dos outros sites deste servidor (o certbot daqui não tem o plugin nginx).
# Aceita os termos de uso da Let's Encrypt em nome do dono do servidor.
if [ ! -f "$CERT/fullchain.pem" ]; then
  vhost http
  certbot certonly --webroot -w "$RAIZ" -d "$DOMINIO" --non-interactive --agree-tos --register-unsafely-without-email
fi
vhost https
echo "OK: https://$DOMINIO no ar"
