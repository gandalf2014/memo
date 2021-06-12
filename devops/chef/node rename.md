# DXC Prod chef node rename
> Reference wiki page [GeneralWorkflowforChefNodes](https://confluence.csc.com/display/DEVOPS/TSA+Exit+-+General+Workflow+for+Chef+Nodes)


# Local chef env  steps
### Step1. on node
- rename node hostname
    - show old name `hostname -f`
    - set new name `hostname chef-node1.demo`,`hostname -f`
    - backup & remove old client.pem `mv /etc/chef/client.pem /etc/chef/client.pem.bak`
    - run `chef-client` to check new name working with chefserver. this step will create new node on server, and will get new client.pem in /etc/chef

### Step2 on workstation
-   `cd /root/chef-repo`
-  ` knife node list` whiich shows old & new node
-  `knife client list` which shows old & new client (public key)
-  get old node runlist
```ruby
[root@chef-workstation chef-repo]# knife node show chef-node1 
Node Name:   chef-node1                                       
Environment: _default                                         
FQDN:        chef-node1                                       
IP:          10.0.2.15                                        
Run List:    recipe[starter]                                  
Roles:                                                        
Recipes:                                                      
Platform:    centos 7.6.1810                                  
Tags:                                                         
```

- validate new node has empty runlist

```ruby
[root@chef-workstation chef-repo]# knife node show chef-node1.demo
Node Name:   chef-node1.demo
Environment: _default
FQDN:        chef-node1.demo
IP:          10.0.2.15
Run List:
Roles:
Recipes:
Platform:    centos 7.6.1810
Tags:
```

- add old runlist into new node
```
[root@chef-workstation chef-repo]# knife node run_list set chef-node1.demo "recipe[starter]"
chef-node1.demo:
  run_list: recipe[starter]
```

### Step3 validate new runlist take effect in new node
- run `chef-client` on new name node
- check runlist already there.
```shell
[root@chef-node1 chef]# chef-client
Starting Chef Infra Client, version 15.1.36
[2019-07-30T08:20:13+00:00] INFO: *** Chef Infra Client 15.1.36 ***
[2019-07-30T08:20:13+00:00] INFO: Platform: x86_64-linux
[2019-07-30T08:20:13+00:00] INFO: Chef-client pid: 3128
[2019-07-30T08:20:18+00:00] INFO: Run List is [recipe[starter]]
[2019-07-30T08:20:18+00:00] INFO: Run List expands to [starter]
```
### Step4 add node in existing environemnt
- run  `knife node environment set chef-node1 test`
```ruby
[root@chef-workstation chef-repo]# knife environment list
_default
test
[root@chef-workstation chef-repo]# knife node environment set chef-node1 test
chef-node1:
  chef_environment: _default
[root@chef-workstation chef-repo]# knife node show chef-node1
Node Name:   chef-node1
Environment: test
FQDN:        chef-node1
IP:          10.0.2.15
Run List:    recipe[starter]
Roles:
Recipes:
Platform:    centos 7.6.1810
Tags:
```


> ***After those steps, there will have old & new node/client on chef-server***

### Step5 clean all old node & client on chef server from wokstation
-   `knife node delete chef-node1`
-   `knife client delete chef-node1`
-   verify `knife node list & knife client list` which output without old name