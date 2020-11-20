#!/bin/zsh
mkdir -p ssl_certs
openssl req -x509 -out ssl_certs/self-signed-spoof-cert.crt -keyout ssl_certs/self-signed-spoof-cert.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=§hostname_to_spoof§' -extensions EXT -config <( \
   printf "[dn]\nCN=§hostname_to_spoof§\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:§hostname_to_spoof§\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

echo "Certificates written to ssl_certs/"
