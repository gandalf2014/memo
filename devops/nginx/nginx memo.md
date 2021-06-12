# Nginx memo

## config 443
    - ssl received a record that exceeded the maximum permissible length nginx
    - add `443 ssl` in config file
    
## reverse proxy with web app with root context
```
 location  ~ ^/blog/(.*)$ {
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;

        proxy_set_header Accept-Encoding "";
        proxy_pass http://192.168.33.11:8080/$1$is_args$args ;
        sub_filter_once off;
        sub_filter  '"/'  '"/blog/';
        sub_filter "'/"   "'/blog/" ;
        proxy_redirect http://joomla/ https://192.168.33.11/blog/;

    }
```
> #### `lynx` which is a text-based browser