# docker installation steps
- there have multi methods to install docker, for simplify the installation, just use the scripts to setup docker on ubuntu

## run the script 
```
curl -fsSL https://get.docker.com -o get-docker.sh
 DRY_RUN=1 sh ./get-docker.sh
 ```

### To run Docker as a non-privileged user, consider setting up the Docker daemon in rootless mode for your user:
```
    dockerd-rootless-setuptool.sh install
```

- ### To control docker.service, run: `systemctl --user (start|stop|restart) docker.service`
- ### To run docker.service on system startup, run: `sudo loginctl enable-linger vagrant`


## Or you can install docker via docker-machine to provision VM with docker deamon.