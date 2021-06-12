```
[root@pln-cd1-ngp-dev1 ~]# docker exec -it ngp-nginx /bin/sh
/ # cat /etc/nginx/conf.d/ngp_nginx.conf
upstream ngp_docker_visualizer {
    server 204.104.1.152:8088;
}

upstream ngp_jenkins {
    server 204.104.1.152:8083;
}

upstream ngp_nexus {
    server 204.104.1.153:8081;
}

upstream ml_docker_registry {
    server 204.104.1.153:9999;
}

upstream ngp_jupyter {
    server 204.104.1.154:8888;
}

upstream ml_lending_assessment {
    server 204.104.1.154:9898;
}

upstream sonarqube {
    server 204.104.1.154:9000;
}

server {
    listen          80;
    listen          443 ssl;
    server_name     devopsdxc.tk;
    ssl_certificate /etc/nginx/www.devopsdxc.tk.pem;
    ssl_certificate_key /etc/nginx/www.devopsdxc.tk.key;
    ssl_session_cache shared:SSL:10m;
    proxy_http_version 1.1;
    ssl_session_timeout 1h;
    ssl_session_tickets off;
    ssl_protocols TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'AES256-GCM-SHA384:AES256-SHA256:ECDHE-RSA-DES-CBC3-SHA:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES128-GCM-SHA256:AES128-SHA256:AES128-GCM-SHA256';
    add_header X-Frame-Options SAMEORIGIN;
    proxy_send_timeout 120;
    proxy_read_timeout 300;
    proxy_buffering off;
    keepalive_timeout 5 5;
    tcp_nodelay on;

    location /jenkins {
      proxy_pass      https://ngp_jenkins/jenkins;
    }

    location / {
      client_max_body_size 0;
      chunked_transfer_encoding on;
      add_header Docker-Distribution-Api-Version: registry/2.0 always;
      proxy_set_header Connection "";
      set $url http://ngp_nexus$request_uri;
      if ($http_user_agent ~* "docker" ) {
          set $url http://ml_docker_registry;
      }
      if ($http_user_agent ~* "Chrome|Mozilla")  {
          set $url http://ngp_nexus;
      }
      proxy_pass $url;
      proxy_set_header   Host             $host;
      proxy_set_header   X-Real-IP        $remote_addr;
      proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto "https";
      proxy_set_header   X-Forwarded-Port $server_port;
      proxy_redirect off;
    }

    location /jupyter {
        proxy_pass      http://ngp_jupyter;
    }

    location ~ /jupyter/api/kernels/ {
        proxy_pass            http://ngp_jupyter;
        proxy_set_header      Host $host;
        # websocket support
        proxy_http_version    1.1;
        proxy_set_header      Upgrade "websocket";
        proxy_set_header      Connection "Upgrade";
        proxy_read_timeout    86400;
    }

    location ~ /jupyter/terminals/ {
        proxy_pass            http://ngp_jupyter;
        proxy_set_header      Host $host;
        # websocket support
        proxy_http_version    1.1;
        proxy_set_header      Upgrade "websocket";
        proxy_set_header      Connection "Upgrade";
        proxy_read_timeout    86400;
    }

    location /lending-assessment {
        proxy_pass      http://ml_lending_assessment/lending-assessment;
    }

    location /sonarqube {
        proxy_pass      http://sonarqube;
    }

    location /dockerv {
        proxy_pass      http://ngp_docker_visualizer/visualizer;
    }

}/ #

```