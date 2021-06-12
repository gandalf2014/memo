# Docker Lab
- > https://training.play-with-docker.com/
- > https://training.play-with-docker.com/alacart/

# Docker Machine 

- `docker-machine env test`
- `eval $(docker-machine env test1)`

>above 2 commands bring remote docker env to local that make local develop easy

- docker-machine create test1
- docker pull nginx
- `docker run --name my-nginx --restart always -p 80:80 -v /vagrant:/usr/share/nginx/html:ro -d  nginx`


## mount remote path to local windows
> https://github.com/billziss-gh/sshfs-win

### add sshfs in window environment path

- > docker-machine mount test1:/home/docker/ /c/nginx/html2

> **Note** `docker-machine mount` don't worked in my windows, but we can map network driver in window file exploer `\\sshfs\gandalf@centos7`, in my test, there just map user's home folder, or install `win-sshfs` to map linux volume to local

### docker-machine create vm base on existing vm

> need put id_rsa.pub into vm .ssh/authorized_key file then run below command:

- docker-machine --debug create  --driver generic  --generic-ip-address 192.168.33.12 --generic-ssh-key ~/.ssh/id_rsa ubuntu16

- docker-machine --debug create  --driver generic  --generic-ip-address 192.168.33.11 --generic-ssh-key ~/.ssh/id_rsa centos7

- docker-machine --debug create  --driver generic  --generic-ip-address 192.168.33.15 --generic-ssh-key ~/.ssh/id_rsa centos-node1


- docker run  -d --link my-nginx -p 4040 wernight/ngrok ngrok http my-nginx:80

```
docker cp sources.list chef-server:/etc/apt/sources.list
```

## Ngrok
- docker run -d --name=ngrok1 -p 4040:4040 --link demo-ghost wernight/ngrok ngrok http demo-ghost:2368
>http://localhost:4040


# Docker Buildkit
>To enable docker buildkit by default, set daemon configuration in /etc/docker/daemon.json feature to true and restart the daemon:

`{ "features": { "buildkit": true } }`

![docker engine](https://www.docker.com/sites/default/files/d8/styles/large/public/2018-11/Docker-Website-2018-Diagrams-071918-V5_a-Docker-Engine-page-first-panel.png?itok=TFiL1wtt)

---
![DIR](https://www.docker.com/sites/default/files/d8/styles/large/public/2018-11/DTR-orchestration-security_0.png?itok=RrYOhITj)

![docker enterprise](https://www.docker.com/sites/default/files/d8/styles/large/public/2018-11/Docker-Website-2018-Diagrams-docker-enterprise-why-docker.png?itok=PsdoDFbt)