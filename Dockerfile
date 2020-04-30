FROM nginx

COPY ssl_certs/ /ssl_certs
COPY nginx.conf /etc/nginx/nginx.conf
