# Jupyterhub 
## local
-  http://192.168.33.18/hub/admin
> jupyter / qq42201186
demo /demo
gandalf / 2019


## install on ubuntu18
> https://the-littlest-jupyterhub.readthedocs.io/en/latest/install/custom-server.html

>jupyterlab


## build jupyterhub docker image
> http://tljh.jupyter.org/en/latest/contributing/dev-setup.html

` jiayouilin/tljh-jupyterhub:1.1.2 `

```ruby
docker run \
  --privileged \
  --detach \
  --name=jupyterhub \
  --publish 8888:80 \
  --mount type=bind,source=$(pwd),target=/srv/src \
  jiayouilin/tljh-jupyterhub:1.1.2
```

- **`docker run -d  --privileged --name=jupyterhub   -p 8888:80      jiayouilin/jupyterhub:1.1.2`**
- **`sudo -E conda install -c conda-forge scijava-jupyter-kernel `**



## docker container
> http://192.168.33.11:8888/hub/home
admin /admin


# HTTPS and SSL/TLS certificate
- This deployment configures JupyterHub to use HTTPS. You must provide a certificate and key file in the JupyterHub configuration. To configure:
Obtain the domain name that you wish to use for JupyterHub, for example, myfavoritesite.com or jupiterplanet.org.

- If you do not have an existing certificate and key, you can:
obtain one from Let's Encrypt using the certbot client,
use the helper script in this repo's letsencrypt example, or
create a self-signed certificate.

- Copy the certificate and key files to a directory named secrets in this repository's root directory. These will be added to the JupyterHub Docker image at build time. For example, create a secrets directory in the root of this repo and copy the certificate and key files (jupyterhub.crt and jupyterhub.key) to this directory:
`mkdir -p secrets
cp jupyterhub.crt jupyterhub.key secrets/`