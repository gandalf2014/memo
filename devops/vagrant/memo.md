###
`
  Encoding.default_external = 'GBK'
  config.vm.box = "centos/7"
  config.vm.hostname = "centos7"
  config.vm.box_url ="file:///D:/vagrant/box/CentOS-7.8.2004.box"
  `

## vagrant ssh stuck 
> ### 关闭本机代理可以解决


## 共享文件夹centos, VM 启动后首先yum update -y


# 只在第一次创建vm时 运行vagrant up 否则可能会遇到vagrant ssh 登陆问题 , 使用virtualbox启动vm


# vagrant plugin install vagrant-vbguest

# enable proxy
- export http_proxy=http://192.168.33.140:7890
- export https_proxy=https://192.168.33.140:7890

- yum update -y







