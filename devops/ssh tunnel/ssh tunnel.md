### SSH Tunning pln.dev1 (local access remote service)
- > ssh -v -C -N -L 0.0.0.0:443:204.104.1.152:443  hpjiayo@204.104.5.221
- > ssh -L 9000:localhost:5432 user@example.com (this `localhost` means to example server only, forward local port 9000 to server 5432, `psql -h localhost -p 9000`)

### SSH connect Remote via proxy
- > `ssh -o ProxyCommand="Connect -H web-proxy.houston.dxccorp.net:8080 %h %p" hpjiayo@204.104.5.221 `
-  > `ssh -J serveo.net user@myalias`
-  > The -J option was introduced in the OpenSSH client version 7.3

### local port forward
- > ssh -L 127.0.0.1:80:intra.example.com:80 gw.example.com

### remote port forward (local service need to be access remotely)
> to enable remote port forward on, need change remote servers sshd config files
- add `GatewayPorts yes` /etc/ssh/sshd_config, and restart `service sshd restart`
> examples:
- > `ssh -R \*:38000:localhost:8080 -NT -i .ssh/id_rsa root@192.168.33.11`

- > `ssh -R 0.0.0.0:38000:0.0.0.0:8080 -NT -i .ssh/id_rsa root@192.168.33.11`
- > `ssh -R [::]:38000:0.0.0.0:8080 -NT -i .ssh/id_rsa root@192.168.33.11`
------
> above 3 lines to expose local tomcat 8080 service to 192.168.33.11:38000 `http://192.168.33.11:38000`
> if you want to expose local tomcat serice to internet, try to use `ngrok` or `serveo.net`
- > `ssh -R 52.194.1.73:8080:localhost:80 host147.aws.example.com`
- > `ssh -R 2222:d76767.nyc.example.com:22 -R 5432:postgres3.nyc.example.com:5432 aws4.mydomain.net`

- > `lsof | grep 38000`

### open ssh without tty
> ## `ssh -nNT atc.ca` 