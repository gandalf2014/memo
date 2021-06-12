## Docker VS K8S

- `docker-machine` to create container remotely
- `docker container env` to bring remote docker setting to local 

### docker file:
- `from scrach` to build base-image
- `from centos`, using base-image
- RUN --all command should be in-line
- CMD --default to execute canbe overrite by `docker run centos "/bin/bash"`
- ENTRYPOINT --used for staring service, it always running

> docker provide a image registry for create private docker registry

- remove all container
  - `docker rm $(docker ps -aq)`

- remove all stopped container 
  - `docker rm $(docker ps -f "status=exited" -qa)`

- docker run pass parameter into container or use -e parameter of docker run
  in dockerfile
  `ENTRYPOINT ['/usr/bin/stress']`
  `CMD []`

### docker network

- `docker network create my-bridge`
- `docker network ls`
- `docker network connect my-bridge test1`
- `docker network connect my-bridge test2`
- `ip netns ls`




> **container no need to map port to local cause there just access by others container, use --link to connect them. or docker network connect to customerized bidge(default is docker0)**