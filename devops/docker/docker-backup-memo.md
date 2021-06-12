# Docker memo

> `docker cp` command can copy into /out of container when container is running and stopped

## docker-machine ssh in mobaXterm
-  `alias dm="docker-machine --native-ssh ssh"`
-  `dm centos7`


## docker container backup
- backup container without backup volume
- `docker commit` & `docker save ` &  `docker load` 
- backup container file system `docker export` & `docker import`

## backup container volume
- `sudo docker run -rm --volumes-from $CONTAINER_NAME -v $(pwd):/backup busybox tar cvf /backup/backup.tar $VOLUME_NAME`
- restore: `sudo docker run -rm --volumes-from $NEW_CONTAINER_NAME -v $(pwd):/backup busybox tar xvf /backup/backup.tar`
- scripts to backup `https://github.com/discordianfish/docker-backup` 

# Dock container backup test steps
> **Note** cause there have some mannully changes in container which not included in volume, so please backup filesystem firstly, and then backup volumes, for restore, need to create new container with committed images and re-binding volumes.


## Part I backup container without volume
### Way1: save image tag to tar
- dock commit
```ruby
[root@centos7 ~]# docker commit backup backup:0802
docker commit backup backup:0802
sha256:4432c26da8e511b9fefe723a76371bbacbf58b71b5b9ff075e3c55fe27fa218e
[root@centos7 ~]# docker images
docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
backup                      0802                4432c26da8e5        5 seconds ago       5.58MB

```
- docker save image to tar
```
[root@centos7 ~]# docker save -o ./backup.0802.tar backup:0802
docker save backupdocker save -o ./backup.0802.tar backup:0802
[root@centos7 ~]# ls -al
ls -al
total 7620
dr-xr-x---.  7 root root    4096 Aug  2 04:21 .
dr-xr-xr-x. 19 root root     267 Jul 25 04:08 ..
-rw-------.  1 root root    5570 Feb 28 20:54 anaconda-ks.cfg
-rw-------   1 root root 5859840 Aug  2 04:21 backup.0802.tar
```

- remove old container and image
```
[root@centos7 ~]# docker rm -f backup
docker rm -f backup
backup
[root@centos7 ~]# docker rmi backup:0802
docker rmi backup:0802
Untagged: backup:0802
Deleted: sha256:4432c26da8e511b9fefe723a76371bbacbf58b71b5b9ff075e3c55fe27fa218e
Deleted: sha256:a0e45915d84049767cac665a814dd832b8b231c6134ff2dd86c351b5f0cce750
[root@centos7 ~]# docker ps
```
### restore container without volume
- restore container
```ruby
[root@centos7 ~]# docker load -i ./backup.0802.tar
docker load ./backdocker load -i ./backup.0802.tar
83d95f0a09f1: Loading layer  3.584kB/3.584kB
Loaded image: backup:0802
[root@centos7 ~]# docker images
docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
backup                      0802                4432c26da8e5        4 minutes ago       5.58MB
[root@centos7 ~]# docker run -dit backup:0802
docker run -dit backup:0802
44818e688cf4d773fedad75011d4e74ee640f9688f1bc1a456b796c75ea1f117
[root@centos7 ~]# docker exec 44818e688cf4 /bin/sh -c "cat rename.sh"
docker exec 44818edocker exec 44818e688cf4 /bin/sh -c "cat rename.sh"
#!/bin/bash
node_fqdn=`hostname -f`
echo "node fqdn: $node_fqdn" > fqdn.txt

if grep 'mcloud.entsvcs.com$' fqdn.txt > /dev/null; then
        echo "matched"
else
        echo "node matched"
fi

```

## Way2: backup&restore container file system 
### backup file system
```
[root@centos7 ~]# docker export -o ./test.tar backup
docker export -o ./test.tar backup
```
### docker import (commit new file system change to image)
```
[root@centos7 ~]# docker import -m "add test.sh" ./test.tar backup:0802                                                                            0  backup:0802
docker import -m "docker import -m "add test.sh" ./test.tar backup:  backup:0802
[root@centos7 ~]# docker images
docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
backup                      0802                2f12fcf2c379        10 seconds ago      5.58MB
```
### validate
```
[root@centos7 ~]# docker run -dit --name backup backup:0802 /bin/sh
docker run -dit --name backup backup:0802 /bin/sh
267647d7cad2ebfa826fd8aa93d011d1fcb1757bc9b25ec183c12ffc125d70ff
[root@centos7 ~]# docker exec backup /bin/sh -c "ls *.sh
docker exec backup /bin/sh -c "ls *.sh"
rename.sh
test.sh
```

## Part II backup data volume
> **Note**: export result of `docker inspect containername`

### view inspect result
```
docker inspect test
  "Mounts": [
            {
                "Type": "volume",
                "Name": "d9d1baac71b8e57b5f8a6ab0517295076d87ac136f9ae5e194c28a6996d14468",
                "Source": "/var/lib/docker/volumes/d9d1baac71b8e57b5f8a6ab0517295076d87ac136f9ae5e194c28a6996d14468/_data",
```
### mv the volume or rync source to other place
```ruby
[root@centos7 _data]# docker exec test /bin/sh -c "ls -al /opt/work/"
total 4
drwxr-xr-x    2 root     root            23 Aug  2 05:43 .
drwxr-xr-x    1 root     root            18 Aug  2 05:57 ..
-rw-r--r--    1 root     root             6 Aug  2 05:43 test2.txt
[root@centos7 _data]# docker exec test /bin/sh -c "echo 'test2' > /opt/work/test3.txt"
[root@centos7 _data]# cd /var/lib/docker/volumes/d9d1baac71b8e57b5f8a6ab0517295076d87ac136f9ae5e194c28a6996d14468/_data
[root@centos7 _data]# ls -al
total 8
drwxr-xr-x 2 root root 40 Aug  2 05:58 .
drwxr-xr-x 3 root root 19 Aug  2 05:40 ..
-rw-r--r-- 1 root root  6 Aug  2 05:43 test2.txt
-rw-r--r-- 1 root root  6 Aug  2 05:58 test3.txt
[root@centos7 ~]# docker rm -f test
test
[root@centos7 ~]# mv  /var/lib/docker/volumes/d9d1baac71b8e57b5f8a6ab0517295076d87ac136f9ae5e194c28a6996d14468 /var/lib/docker/volumes/data
[root@centos7 ~]# cd /var/lib/docker/volumes/data
[root@centos7 data]# ls -al
total 0
drwxr-xr-x  3 root root  19 Aug  2 05:40 .
drwx------. 6 root root 193 Aug  2 06:00 ..
drwxr-xr-x  2 root root  40 Aug  2 05:58 _data
[root@centos7 data]# cd _data/
[root@centos7 _data]# ls -a
.  ..  test2.txt  test3.txt
[root@centos7 _data]# pwd
/var/lib/docker/volumes/data/_data
```
### restore and rebind volume
```
[root@centos7 _data]# docker run -v /var/lib/docker/volumes/data/_data:/opt/work  -dit --name test alpine /bin/sh
c2f6984b614cca5a2bcc724277834eb04f104e0e3d4ff005f04dfb1bfc2823a2
[root@centos7 _data]# docker exec test /bin/sh -c "ls -al /opt/work/"
total 8
drwxr-xr-x    2 root     root            40 Aug  2 05:58 .
drwxr-xr-x    1 root     root            18 Aug  2 06:01 ..
-rw-r--r--    1 root     root             6 Aug  2 05:43 test2.txt
-rw-r--r--    1 root     root             6 Aug  2 05:58 test3.txt
```




## Part III backup databinds
- in this case, there just use `rsync` or `tar` to backup binds folder
- restore  to rebinds 

## SSHFS 

- yum install epel-release
- yum install fuse-sshfs

```
sshfs  -o allow_other,default_permissions gandalf@centos7:/opt/work/ /root/jenkins_data/
```






