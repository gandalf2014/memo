# Install Chef Server

> https://docs.chef.io/install_server.html#standalone
- download https://packages.chef.io/files/stable/chef-server/13.0.17/el/7/chef-server-core-13.0.17-1.el7.x86_64.rpm
- sudo rpm -Uvh /tmp/chef-server-core*.rpm
-  chef-server-ctl reconfigure


# Configure  Manage UI console
One way to install the Management Console is to log in as root and type these commands:

- chef-server-ctl install chef-manage 
- chef-server-ctl reconfigure 
- chef-manage-ctl reconfigure 

or mannuly download UI `https://packages.chef.io/files/stable/chef-manage/2.5.16/el/7/chef-manage-2.5.16-1.el7.x86_64.rpm`

> **Note**: if you install chef manager in docker, it will stuck by `ruby_block[wait for redis service socket] action run`, please run `/opt/chef-manage/embedded/bin/runsvdir-start &` before install chef manager UI, docker image `cbuisson/chef-server`

> /opt/chef-manage/embedded/service/chef-manage/config/compass.rb

# Chef Workstation
- https://www.chef.sh/docs/chef-workstation/getting-started/
- https://packages.chef.io/files/stable/chef-workstation/0.7.4/el/7/chef-workstation-0.7.4-1.el7.x86_64.rpm

> - the above rpm no need to install if you just want only use knife tool
> - workstation only need download a starterkit from UI (`https://192.168.33.9/organizations/vpc_devops/getting_started`) which include knife.rb and copy server crt to local

### configuration on workstation
-  unzip starterkit
-  copy server ca cert to local to fix ssl issue
-  config private key 
```ruby
[root@chef-workstation .chef]# ls -al
total 8
drwxr-xr-x. 3 root root   62 Jul 27 04:03 .
drwxr-xr-x. 5 root root   84 Jul 27 03:53 ..
-rw-r--r--. 1 root root 1674 Jul 27 03:25 gandalf.pem
-rw-r--r--. 1 root root  423 Jul 27 03:25 knife.rb
drwxr-xr-x. 2 root root   29 Jul 27 04:03 trusted_certs
[root@chef-workstation .chef]# cat knife.rb
# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "gandalf"
client_key               "#{current_dir}/gandalf.pem"
chef_server_url          "https://chef-server/organizations/vpc_devops"
cookbook_path            ["#{current_dir}/../cookbooks"]
[root@chef-workstation .chef]# pwd
/root/chef-repo/.chef
```


# Chef node
- method1: https://docs.chef.io/install_bootstrap.html
- method2: https://docs.chef.io/install_omnibus.html

### installation steps
- download `https://packages.chef.io/files/stable/chef/15.1.36/el/7/chef-15.1.36-1.el7.x86_64.rpm`
- `rpm -Uvh chef-15.1.36-1.el7.x86_64.rpm`
- copy server ca cert to `/etc/chef/trusted_certs`,copy `org-validate.pem` to local and then create new `/etc/chef/client.rb`
```shell
[root@chef-node1 chef]# ls -al
total 32
drwxr-xr-x.  4 root root  148 Jul 27 06:59 .
drwxr-xr-x. 80 root root 8192 Jul 27 06:17 ..
drwxr-xr-x.  2 root root   45 Jul 27 06:03 accepted_licenses
-rw-r--r--.  1 root root   36 Jul 27 06:48 chef_guid
-rw-------.  1 root root 1679 Jul 27 06:59 client.pem
-rw-------.  1 root root 1679 Jul 27 06:56 client.pem.bak
-rw-r--r--.  1 root root  177 Jul 27 06:46 client.rb
drwxr-xr-x.  2 root root   29 Jul 27 06:24 trusted_certs
-rw-r--r--.  1 root root 1675 Jul 27 06:14 validation.pem
[root@chef-node1 chef]# cat client.rb
log_level                :info
log_location             STDOUT
ssl_ca_path              "/etc/chef/trusted_certs"
chef_server_url          "https://chef-server/organizations/vpc_devops"


```


# local vagrant chef-server

- `sudo chef-server-ctl user-create gandalf youlin Jia you-lin.jia@dxc.com 'gandalf123' --filename /vagrant/gandalf.pem`
- `sudo chef-server-ctl org-create vpc_devops 'chef team' --association_user gandalf --filename /vagrant/devops-validator.pem`


# Fix workstation ssl error
- copy crt from chef-server to workstation

> By default, the certificate is stored in the following location on the
host where your chef-server runs:

 ` /var/opt/opscode/nginx/ca/SERVER_HOSTNAME.crt`

- Copy that file to your trusted_certs_dir (currently:

 ` /Users/grantmc/Downloads/chef-repo/.chef/trusted_certs`

- knife ssl check