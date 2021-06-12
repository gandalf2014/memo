# Nginx CheatSheet

## General Settings
### Port (listen)
```
server {
  # standard HTTP protocol
  listen 80;
  
  # standard HTTPS protocol
  listen 443 ssl;
  
  # listen on 80 using IPv6
  listen [::]:80;
  
  # listen only on IPv6
  listen [::]:80 ipv6only=on;
}
```
### Domain name (server_name)
```
server {
  # Listen to yourdomain.com
  server_name yourdomain.com;
  
  # Listen to multiple domains
  server_name yourdomain.com www.yourdomain.com;
  
  # Listen to all sub-domains
  server_name *.yourdomain.com;
  
  # Listen to all top-level domains
  server_name yourdomain.*;
  
  # Listen to unspecified hostnames (listens to IP address itself)
  server_name "";
}
```
### Access Logging (access_log)
```
server {
  # Relative or full path to log file
  access_log /path/to/file.log;
  
  # Turn 'on' or 'off'
  access_log on;
}
```
### Miscellaneous (gzip, client_max_body_size)
```
server {
  # Turn gzip compression 'on' or 'off'
  gzip on;
  
  # Limit client body size to 10mb
  client_max_body_size 10M;
}
```
### Serving Files
Static assets
The traditional web server.
```
server {
  listen 80;
  server_name yourdomain.com;
  
  location / {
  	root /path/to/website;
  }
}
```
### Static assets with HTML5 History Mode
Useful for Single-Page Applications like Vue, React, Angular, etc.
```
server {
  listen 80;
  server_name yourdomain.com;
  root /path/to/website;
  
  location / {
  	try_files $uri $uri/ /index.html;
  }
}
```
## Redirects
### 301 Permanent
Useful for handling www.yourdomain.com vs. yourdomain.com or redirecting http to https. In this case we will redirect www.yourdomain.com to yourdomain.com.
```
server {
  listen 80;
  server_name www.yourdomain.com;
  return 301 http://yourdomain.com$request_uri;
}
```
### 302 Temporary
```
server {
  listen 80;
  server_name yourdomain.com;
  return 302 http://otherdomain.com;
}
```
### Redirect on specific URL
Can be permanent (301) or temporary (302).
```
server {
  listen 80;
  server_name yourdomain.com;
  
  location /redirect-url {
	return 301 http://otherdomain.com;  
  }
}
```
## Reverse Proxy
Useful for Node.js applications like express.

### Basic
```
server {
  listen 80;
  server_name yourdomain.com;
  
  location / {
    proxy_pass http://0.0.0.0:3000;
    # where 0.0.0.0:3000 is your Node.js Server bound on 0.0.0.0 listing on port 3000
  }
}
```
### Basic+
```
upstream node_js {
  server 0.0.0.0:3000;
  # where 0.0.0.0:3000 is your Node.js Server bound on 0.0.0.0 listing on port 3000
}

server {
  listen 80;
  server_name yourdomain.com;
  
  location / {
    proxy_pass http://node_js;
  }
}
```
### Upgraded Connection (Recommended for Node.js Applications)
Useful for Node.js applications with support for WebSockets like socket.io.
```
upstream node_js {
  server 0.0.0.0:3000;
}

server {
  listen 80;
  server_name yourdomain.com;
  
  location / {
    proxy_pass http://node_js;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
	
    # not required but useful for applications with heavy WebSocket usage
    # as it increases the default timeout configuration of 60
    proxy_read_timeout 80;
  }
}
```
## TLS/SSL (HTTPS)
### Basic
> The below configuration is only an example of what a TLS/SSL setup should look like. Please do not take these settings as the perfect secure solution for your applications. Please do research the proper settings that best fit with your Certificate Authority.

> If you are looking for free SSL certificates, Let's Encrypt is a free, automated, and open Certificate Authority. Also, here is a wonderful step-by-step guide from Digital Ocean on how to setup TLS/SSL on Ubuntu 16.04.
```
server {
  listen 443 ssl;
  server_name yourdomain.com;
  
  ssl on;
  
  ssl_certificate /path/to/cert.pem;
  ssl_certificate_key /path/to/privkey.pem;
  
  ssl_stapling on;
  ssl_stapling_verify on;
  ssl_trusted_certificate /path/to/fullchain.pem;

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;
  add_header Strict-Transport-Security max-age=15768000;
}
```
###  Permanent redirect for HTTP to HTTPS
```
server {
  listen 80;
  server_name yourdomain.com;
  return 301 https://$host$request_uri;
}
```
### Large Scale Applications
#### Load Balancing
Useful for large applications running multiple instances.
```
upstream node_js {
  server 0.0.0.0:3000;
  server 0.0.0.0:4000;
  server 123.131.121.122;
}

server {
  listen 80;
  server_name yourdomain.com;
  
  location / {
    proxy_pass http://node_js;
  }
}
````