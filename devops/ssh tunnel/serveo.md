> https://serveo.net/#alternatives
# remote tunnel 
- > download serveo `https://storage.googleapis.com/serveo/download/2018-05-08/serveo-amd64.exe`
> 把本地的tomcat 服务8080 tunnel到serveo.net上

- > 运行命令`C:\Users\Administrator>serveo-amd64.exe --private_key_path=.ssh/id_rsa` 
------------
> 以上部分可以不用做
```shell
Administrator@KGR1LZPZTEL44MV MINGW64 ~
$ ssh -R tomcat.serveo.net:80:localhost:8080 serveo.net
The authenticity of host 'serveo.net (159.89.214.31)' can't be established.
RSA key fingerprint is SHA256:07jcXlJ4SkBnyTmaVnmTpXuBiRx2+Q2adxbttO9gt0M.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'serveo.net,159.89.214.31' (RSA) to the list of known hosts.
Authenticated to serveo.net ([159.89.214.31]:22).
Warning: untrusted X11 forwarding setup failed: xauth key data not generated
Forwarding HTTP traffic from https://gero.serveo.net
Press g to start a GUI session and ctrl-c to quit.
HTTP request from 119.85.107.16 to https://gero.serveo.net/
HTTP request from 119.85.107.16 to https://gero.serveo.net/tomcat.gif
````
> 打开浏览器访问 https://gero.serveo.net

> `ssh -o ServerAliveInterval=60 -R jupyterhub.serveo.net:80:192.168.33.11:8888 serveo.net`

> [jupyterhub](https://jupyterhub.serveo.net)


### autossh
> https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
- **`autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -L 5000:localhost:3306 cytopia@everythingcli.org`**

### hosts serveo  yourself
> `./serveo -private_key_path=.ssh/id_rsa -port=2222 -http_port=8080 -https_port=8443 `


## Alternative Options

### ngrok
- > ngrok http 192.168.33.11:8888
- > http://localhost:4040
- > ngrok free account cannot customerize subdomain like `ngrok http -subdomain=jupyter 192.168.33.11:8888` 
----

### openssh

### sshreach.me