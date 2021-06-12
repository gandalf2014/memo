# Speedup docker in China
通过经典网络、VPC网络内网安装时，用以下命令替换Step 2中的命令
### 经典网络：
> sudo yum-config-manager --add-repo http://mirrors.aliyuncs.com/docker-ce/linux/centos/docker-ce.repo

### VPC网络：
> sudo yum-config-manager --add-repo http://mirrors.could.aliyuncs.com/docker-ce/linux/centos/docker-ce.repo

> sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo


- `sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2`

- `sudo yum install docker-ce docker-ce-cli containerd.io`


# speedup docker hub 
> curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io



> 国内加速访问Docker相关资源
玩转Docker经常需要我们从一些网站上下载一些资源，包括但不仅限于Docker Toolbox，Docker Engine以及各种镜像。但从国内访问这些网站通常非常慢，而且经常会以失败而告终。为了更好的学习和使用Docker，下面分别介绍可以加速访问这些资源的方法，供读者参考。
>Docker Toolbox如果无法通过官网下载，可以选择通过https://get.daocloud.io/#install-toolbox下载最新的版本
Docker Engine
将环境变量MACHINE_DOCKER_INSTALL_URL设置为阿里云提供的地址来加速下载。该地址将被docker-machine create命令用于设定--engine-install-url参数。
`export MACHINE_DOCKER_INSTALL_URL=http://docker-mirror.oss-cn-hangzhou.aliyuncs.com/`
DockerHub阿里云镜像（部分）
针对在阿里云ECS上使用Docker的用户，阿里云同步了部分Docker官方镜像库到国内服务器，目前支持的镜像参见帮助文档。通过给docker-machine create命令指定如下参数，即可在创建机器时从阿里云下载镜像。
`--engine-insecure-registry registry.mirrors.aliyuncs.com`