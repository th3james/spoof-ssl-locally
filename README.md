# Configuring Local SSL
A simple Nginx configuration which will allow you to serve your chosen hostname
with a self-signed SSL certificate from your local machine.
Instructions are only for macOS and zsh (macOS default shell), but it shouldn't
be too hard to work it out for other platforms.

## Usage
### Configure the app
The configuration in this app is templated. Run the configuration script to populate the templated variables:
```shell
./configure-project.sh
```
It will ask for the following:

#### §hostname_to_spoof§
The hostname you want to use your self-signed certificate on.

#### §web_app_container§
The name of the container to proxy requests to.
You can find this by running `docker ps`.

#### §web_app_port§
The port your web app container exposes HTTP on (note, this is the port _inside_ the docker network, not that which is exposed on your host machine).

#### §target_network§
The name of the network the Nginx container will join to proxy requests to.
You can find this by running `docker network ls` while the target app is
running, by default it is `<dirname>_default`.

Once this is done, your provided variables will override the §templated§ values.

### Generate an SSL certificate
Next the script will ask if you want to generate SSL certs.

[This uses openssl](https://letsencrypt.org/docs/certificates-for-localhost/)

You can do this later by running:
```shell
./generate-certs.sh
```

#### Trust the generated certificate
The self-signed certificates will be written to `ssl_certs/`. In order to use them you'll need to tell macOS to trust them.

* Open up Keychain Access.
* Drag your certificate into Keychain Access.
* Go into the Certificates section and locate the certificate you just added
* Double click on it, enter the trust section and under "When using this certificate" select "Always Trust"

### Override local DNS look-up to point to your machine
Add the following to /etc/hosts
```
127.0.0.1       §hostname_to_spoof§
```

## Run it
First, bring up your docker web app, the bring this app up:
```
docker-compose up
```
