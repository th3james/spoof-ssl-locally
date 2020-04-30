# Configuring Local SSL
A simple Nginx configuration which will allow you to serve your chosen hostname
with a self-signed SSL certificate from your local machine.

## Variables to define:
In order to use this, you'll need to configure some variables. Each variable is
wrapped in §, you'll need to find-replace them to use this.

### §target_network§
The name of the network the Nginx container will join to proxy requests to.
You can find this by running `docker network ls` while the target app is
running, by default it is `<dirname>_default`.

### §web_app_container§
The name of the container to proxy requests to.
You can find this by running `docker ps`.

### §web_app_port§
The port your web app container exposes HTTP on (note, this is the port _inside_ the docker network, not that which is exposed on your host machine).

### §hostname_to_spoof§
The hostname you want to use your self-signed certificate on.

## Generate an SSL certificate
[Generate own cert with openssl](https://letsencrypt.org/docs/certificates-for-localhost/)

```shell
openssl req -x509 -out ssl_certs/self-signed-spoof-cert.crt -keyout ssl_certs/self-signed-spoof-cert.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=§hostname_to_spoof§' -extensions EXT -config <( \
   printf "[dn]\nCN=§hostname_to_spoof§\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```

## Trust the generated certificate

[Trusting own SSL certificate](https://tosbourn.com/getting-os-x-to-trust-self-signed-ssl-certificates/)

* Locate where your certificate file is.
* Open up Keychain Access.
* Drag your certificate into Keychain Access.
* Go into the Certificates section and locate the certificate you just added
* Double click on it, enter the trust section and under “When using this certificate” select “Always Trust”

## Point the hostname at your computer
Add the following to /etc/hosts
```
127.0.0.1       §hostname_to_spoof§
```

## Run it
First, bring up your docker web app, the bring this app up:
```
docker-compose up
```
