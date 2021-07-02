## create user user
`useradd -m -G root,wheel gandalf -p "234234#!qwq"`

### user creation or remove
```
useradd -C "demo user" demo
userdel -r demo

passwd -S demo

passwd -e demo 

passwd -l demo

passwd -u demo

passwd -n 1 -x 90  -w 3 -i 10 demo 
```


### use `CURL` to test service is live

```
 curl -I -s www.tmall.com:443
```

## simple httpserver
`python -m SimpleHTTPServer`

## remove user
1. `userdel gandalf`
2.  `rm -rf /home/gandalf`
3.  `rm -rf /var/spool/mail/gandalf`

## vi /etc/ssh/sshd_config
1.  `PasswordAuthentication yes`
## sudoedit /etc/sudoers
1.  `%wheel  ALL=(ALL)       NOPASSWD: ALL`

## curl & wget
- curl -O -C -L url
- wget -O filename url
- wget url

## awk && grep 
```
[root@centos7 ~]# ps -ef | grep  autossh | grep -v grep
root      3556  3472  0 04:07 pts/0    00:00:00 autossh -M 0 -o ServerAliveInterval 30 -o ServerAliveCountMax 3 -R jupyterhub.serveo.net:80:192.168.33.11:8888 serveo.net
[root@centos7 ~]# ps -ef | grep  autossh | grep -v grep | awk -F ' ' '{print $15}'
ServerAliveCountMax
[root@centos7 ~]# ps -ef | grep  autossh | grep -v grep | awk -F ' ' '{print $NF}'
serveo.net

```
## Rsync
**Note** local push to remote better than pull from remote(no permission denied)

```ruby
    docker commit chef-workstation chef-workstation:20190805
    docker commit chef-server chef-server:20190805
    docker commit chef-node1 chef-node1:20190805
    docker commit ngp-jenkins ngp-jenkins:20190805
    docker commit ngp-nginx ngp-nginx:20190805
    docker commit ngp-proxy ngp-proxy:20190805

    docker save -o /opt/chef-workstation-20190805.tar.gz  chef-workstation:20190805
    docker save -o /opt/chef-server-20190805.tar.gz  chef-server:20190805
    docker save -o /opt/chef-node1-20190805.tar.gz  chef-node1:20190805
    docker save -o /opt/ngp-jenkins-20190805.tar.gz  ngp-jenkins:20190805
    docker save -o /opt/ngp-nginx-20190805.tar.gz  ngp-nginx:20190805
    docker save -o /opt/ngp-proxy-20190805.tar.gz  ngp-proxy:20190805

    docker commit sonarqube sonarqube:20190805
    docker commit ngp-nexus ngp-nexus:20190805
    docker save -o /opt/sonarqube-20190805.tar.gz  sonarqube:20190805
    docker save -o /opt/ngp-nexus-20190805.tar.gz  ngp-nexus:20190805
```
### scripts
#### dev2 scripts
```shell
#!/bin/bash
containers=( sonarqube ngp-nexus )
for i in "${containers[@]}"
do
        echo docker commit $i $i:`date +%Y%m%d`
        echo docker save -o /opt/$i:`date +%Y%m%d`.tar.gz $i:`date +%Y%m%d`
done

SSHPASS=Fl2pOVMYLgA1hQyCIH3i rsync --rsh='sshpass -e ssh -l gandalf' -avzrP --stats --delete /opt/*.tar.gz  gandalf@pln-cd1-ngp-dev3:/opt/devopsbackup/docker-images/

SSHPASS=Fl2pOVMYLgA1hQyCIH3i rsync --rsh='sshpass -e ssh -l gandalf' -avzrP --stats --delete  /var/lib/docker/volumes/9fd67e226413dc19adf4fe3ccbd88ccb7ef74266532f2268742b814a298e89b9  gandalf@pln-cd1-ngp-dev3:/opt/devopsbackup/sonar/

SSHPASS=Fl2pOVMYLgA1hQyCIH3i rsync --rsh='sshpass -e ssh -l gandalf' -avzrP --stats --delete /opt/nexus-data  gandalf@pln-cd1-ngp-dev3:/opt/devopsbackup/
```
---
## for more details info about sshpass, read about https://www.redhat.com/sysadmin/ssh-automation-sshpass
#### dev1 scripts
```shell
#!/bin/bash
containers=( ngp-jenkins ngp-proxy ngp-nginx )
for i in "${containers[@]}"
do
        echo docker commit $i $i:`date +%Y%m%d`
        echo docker save -o /opt/$i:`date +%Y%m%d`.tar.gz $i:`date +%Y%m%d`
done

SSHPASS=Fl2pOVMYLgA1hQyCIH3i rsync --rsh='sshpass -e ssh -l gandalf' -avzrP --stats --delete /opt/*.tar.gz  gandalf@pln-cd1-ngp-dev3:/opt/devopsbackup/docker-images/

SSHPASS=Fl2pOVMYLgA1hQyCIH3i rsync --rsh='sshpass -e ssh -l gandalf' -avzrP --stats --delete /opt/jenkins-data  gandalf@pln-cd1-ngp-dev3:/opt/devopsbackup/
```
### docker jenkins start
`docker run -dit  -p 8083:8083 -p 50000:50000 -p 8080:8080 --name ngp-jenkins --restart always -v /opt/jenkins-data:/var/jenkins_home  -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker -v /usr/lib64/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7   204.104.1.152:8102/ngp-jenkins `

### docker sonarqube
`docker run -dit --name sonarqube --restart always -p 9000:9000 -v /opt/sonarqube/_data:/opt/sonarqube/data sonarqube`

### docker ngp-nexus
`docker run -dit --name sonarqube --restart always -p 9999:9999 -p 8081:8081 -v /opt/nexus-data:/nexus-data ngp-nexus sonatype/nexus3 sh -c "${SONATYPE_DIR}/start-nexus-repository-manager.sh"`


## dd/df/du
- `dd if=test.tar of=test.tar2` like `cp`,`scp`,`rsync`
- `df -h`   查看分区大小
- `du --max-depth=1 -c -h` 查看文件夹大小

## lscpu/lshw/lsmem

### common usefull shortcuts

1. ctl+r (inverse grep history)
2. ctl+x,e (emacs)
3. ctl+l  (clear)
4. ctl+x,c (exit  emacs)
5. mv test.{tar,tar.gz}
6. curl ifconfig.me (external IP)-- hostname -I
7. ctrl+a,ctl+e,ctl+u(clear before cursor),ctl+k (clear after)
8. ctl+_ (undo),ctl+d (logout)
9. ctl+b,ctl+f ,ctl+d(<--- ,----->) (alt+f,alt+b,alt+d move a word)
10. time read (stop: ctl+d)
11. ctl+z (current to background, fg)
12. ctl+t,alt+t (swap a character/word)
13. ctl+w (cut), ctl+y (pasted)
14. alt+U,alt+L (upper/lower case)
15. ctl+p (upper), ctl+n(next)
16. alt+R (revert changes of a command which pull from history) 
17. set -o vi / set -o emacs

---

### 删除空格
tr -s " "  
tr -d " "

### 获取普通用户名
`eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1`

### 获取空密码的用户
`awk -F":" '($2 == "!!" || $2 == "*") {print $1}' /etc/shadow`

### 锁定账户 并过期
`passwd -l test1 && chage -E0 test1 && usermod -s /sbin/nologin test1`

### 去除#
grep '^[^# ]' /etc/security/pwquality.conf


## echo 变换颜色输出
[root@centos7 data]# red=`tput setaf 1`
[root@centos7 data]# green=`tput setaf 2`
[root@centos7 data]# reset=`tput sgr0`
[root@centos7 data]# echo "${red}red text ${green}green text${reset}"
red text green text

## sudoers
Syntax : User <space> OnHost = (Runas-User:Group) <space> Commands
Example: root ALL = (ALL:ALL) ALL


## 删除空行
awk NF


## 用户登录失败3次锁定账户
> https://www.golinuxhub.com/2018/08/how-to-lock-or-unlock-root-normal-user-pamtally2-pamfaillock-linux/

> `authconfig --passalgo=sha512 --passminlen=17 --passminclass=3 --passmaxrepeat=2 --passmaxclassrepeat=10 \
 --enablereqlower --enablerequpper --enablereqdigit --enablereqother --enablefaillock \
 --faillockargs="deny=3 even_deny_root unlock_time=60" --update`
### 解锁 faillock --user test8 --reset  /  pam_tally2 --user test8 --reset
###
> 个人理解：uid是实际用户id，每个文件都会有一个uid； 用户在登录的过程中，使用的是uid。用户在执行文件时，pID对应的uid就是用户的uid；  euid是用户的有效id，在执行文件的时候，由于权限的问题，某个进程的uid需要‘变为’其他用户才可以执行，这时‘变身’后的用户id及就是euid。 在没有‘变身’的情况下，euid=uid. suid标示一个文件可以被另一个文件使用‘变身’的策略使用它的权限 ，比如上面的/etc/passwd 文件，其他用户只有执行的权限，但是没有读取得权限，其他非root用户在执行的时候，由于文件设置了suid，则执行过程中euid可以被更改为root,这样就可以访问了 。