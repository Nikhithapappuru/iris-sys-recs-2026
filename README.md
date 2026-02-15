# NGINX-PROXY

The objective of this task is to introduce NGINX as reverse proxy.

### Architecture:

Browser(port 80)-> Nginx-> Rails(3000)->MYSQL

Users should only access NGINX
- Rails should not be exposed directly
- Nginx should proxy requests to Rails
- Nginx later must load-balance between 3 Rails containers
- All traffic should go through NGINX

Firstly created a file `nginx.conf`
```
events {}


http {
    upstream rails_app {
        server app:3000;
    }


    server {
        listen 80;


        location / {
            proxy_pass http://rails_app;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

Updated the docker-compose.yml file
- Added the service nginx.

```


  nginx:
    image: nginx:latest
    container_name: nginx-proxy
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
 networks:
      - rails_network


volumes:
  db_data:


networks:
  rails_network:

```

What changed now is that Rails requires a fully initialized environment at runtime because another container (Nginx) depends on it.
In the earlier phase, Rails only talked to the host machine, so Docker’s default startup was enough.

On running the command:
```
docker compose build
```
- reads the docker-compose.yml file
- Find all the services: app, db, nginx
- For each service, the Dockerfile is checked and rebuilds if files are changed.
- New images are created and caches layers for speed.

On running the command:
```
docker compose up
```

This is the error
In the logs , the unexpected line was
rails-app | [ActionDispatch::HostAuthorization::DefaultResponseApp] Blocked hosts: wpad.nitk.ac.in

This happens because:

Windows / corporate networks / college networks automatically request wpad.dat for proxy auto-configuration.

Rails blocks unknown hosts for security → that is why it shows:

Blocked hosts: wpad.nitk.ac.in


The Nginx access log line
nginx-proxy | 172.21.0.1 - - [04/Feb/2026] "GET /wpad.dat HTTP/1.1" 403


This is also because Windows tries to request /wpad.dat.

Nginx receives the request -> passes it to Rails -> Rails blocks it (403).

Solution for this problem is to add config.hosts.clear in the file config/environments/development.rb for the development, so that the Rails accepts the users other than the system host.

There was one more error arised for not running the migrations:

So , run the command:
```
docker compose run app rails db:migrate
```

On running the command 
```
docker compose up
```
The application runs on the port 80
```
http://localhost/
```
