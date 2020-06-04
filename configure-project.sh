#!/bin/zsh

echo "What hostname do you want to spoof?"

read spoof_host

echo "What is your target container called?"

read web_app_container

echo "What port is your container running on?"

read web_app_port

echo "What network is your container in?"

read target_network

LC_ALL=C find -XE . \
  -type f -and -regex "\.\/(docker-compose.yml|generate-certs.sh|nginx.conf)" \
  -exec sed -i '' "s/§hostname_to_spoof§/$spoof_host/g" {} +

LC_ALL=C find -XE . \
  -type f -and -regex "\.\/(docker-compose.yml|generate-certs.sh|nginx.conf)" \
  -exec sed -i '' "s/§web_app_container§/$web_app_container/g" {} +

LC_ALL=C find -XE . \
  -type f -and -regex "\.\/(docker-compose.yml|generate-certs.sh|nginx.conf)" \
  -exec sed -i '' "s/§web_app_port§/$web_app_port/g" {} +

LC_ALL=C find -XE . \
  -type f -and -regex "\.\/(docker-compose.yml|generate-certs.sh|nginx.conf)" \
  -exec sed -i '' "s/§target_network§/$target_network/g" {} +

echo "Generate certificate (y/n)?"
read choice
case "$choice" in 
  y|Y ) /bin/zsh generate-certs.sh;;
  * ) echo "skipping cert generation";;
esac

echo "See readme for instructions on trusting these SSL certificates"

echo "Finally, add this line to /etc/hosts"
echo "127.0.0.1       $spoof_host"
