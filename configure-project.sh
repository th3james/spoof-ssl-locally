#!/bin/sh

LC_ALL=C find -XE . \
  -type f -and -regex "\.\/(docker-compose.yml|generate-certs.sh|nginx.conf)" \
  -exec sed -i '' 's/§hostname_to_spoof§/my-host.lol/g' {} +
