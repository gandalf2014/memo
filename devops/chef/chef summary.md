# 本地实验总结
- chef server 通过`chef-server-ctl` 命令创建user 和org 会得到两个private key。 其中org会得到orgxx-validator.pem
-  chef server 证书`/var/opt/opscode/nginx/ca/chef-server.crt` 拷贝到workstation ` .chef/trusted_certs/chef-server.crt` 可用`knife ssl check` 检查和 node 保存，
-  node 需要设置client.rb 其中ssl_ca_path的值
 ```ruby
[root@chef-node1 chef]# cat client.rb
log_level                :info
log_location             STDOUT
ssl_ca_path              "/etc/chef/trusted_certs"
chef_server_url          "https://chef-server/organizations/vpc_devops"
 ```

# 改hostname
- 通过hostname chef-node1.demo 改为新域名
- run `chef-client` 报错
- 删除`client.pem` 文件，重新run `chef-client`会利用validator.pem 重新注册到chef-server
- 通过  `knife node list` 会查看到新老两个node
```ruby
[root@chef-workstation chef-repo]# knife node list
chef-node1
chef-node1.demo
```
- 通过`knife node delete chef-node1` 删除老域名


### client.rb 参考
> https://docs.chef.io/config_rb_client.html