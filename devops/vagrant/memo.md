###
`
  Encoding.default_external = 'GBK'
  config.vm.box = "centos/7"
  config.vm.hostname = "centos7"
  config.vm.box_url ="file:///D:/vagrant/box/CentOS-7.8.2004.box"
  `

## vagrant ssh stuck 
> ### 关闭本机代理可以解决


## 共享文件夹centos，为VM安装virtualbox guest additions
- vm添加虚拟光盘，加载VBoxGuestAdditions.iso
- 启动VM， vagrant ssh登录到root账户下运行
-  yum -y install epel-release ; yum -y update  ; yum install make gcc kernel-headers kernel-devel perl dkms bzip2
- mount -r /dev/cdrom /media
- cd /media/
- ./VBoxLinuxAdditions.run 




# 只在第一次创建vm时 运行vagrant up 否则可能会遇到vagrant ssh 登陆问题 , 使用virtualbox启动vm


# vagrant plugin install vagrant-vbguest

# enable proxy
export http_proxy=http://10.8.22.153:7890
export https_proxy=http://10.8.22.153:7890

- yum update -y







