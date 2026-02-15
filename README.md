# Data Persistence

The objective of this task is to ensure data is persisted when the container restarts.

So we have only persisted the nginx.config file
In this task we will have persistent nginx configuration files and persistent DB as well.
/etc/nginx/ nginx.conf,conf.d/(default.conf( app1.conf, app2.conf)), mime.types, modules/


The components that are persisted are
- MYSQL data
- NGINX config
- Rails logs


### Docker volumes:

```
volumes:
  db_data:
  nginx_config:
  rails_logs:
```
In the docker-compose.yml file, under the service nginx:
```
- nginx_config:/etc/nginx
```
 is added, so that the nginx directory is persisted in the volume named nginx_config.

Also persisted the rails logs to audit the running of the application:

Added proxy_http_version 1.1 and Connection "" to location/ in the file nginx.conf


By default, Nginx proxies connections using HTTP/1.0,
which does not support persistent connections or WebSockets.
Rails, Puma, and ActionCable all benefit from HTTP/1.1 features.

Setting proxy_http_version 1.1 enables persistent upstream connections.

Clearing the Connection header ensures Nginx does not send
Connection: close, enabling keep-alive and efficient load balancing.
Reduces the backend restart per request.

This results in better performance and avoids dropped connections
in multi-container environments.

On running the command:
```
docker compose up –build
```
The application runs successfully.

On running the command
```
 docker compose down
```
the containers will be removed 
And on running the command 
```
docker volume ls
```
We can see the volumes stored

Inspecting  the volume inside the container through these comamands
``` 
docker run -it --rm -v iris-sys-recs-2026_rails_logs:/data alpine sh
```
```
ls /data
```

We get development.log, which ensures the persistence.

