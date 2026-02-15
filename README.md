# Load-balancing

The main objective of this task is to scale Rails horizontally with 3 containers.

### Architecture:
 NGINX-> app1, app2, app3 -> MYSQL

### Nginx Upstream:

Made changes in the nginx.conf file:

```
upstream rails_app {
    server app1:3000;
    server app2:3000;
    server app3:3000;
}

```

->Now Nginx knows about three backend servers.
->Nginx automatically load balances using round-robin.

Added the headers:
```
server {
        listen 80;


        location / {
            proxy_pass http://rails_app;


           
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

Added the services app1, app2, app3 to the docker-compose.yml file to convert it into a load balanced set up if three containers start.
```
app1:
    build: .
    container_name: rails-app1
    depends_on:
      - db
    environment:
      DATABASE_HOST: db
      DATABASE_USERNAME: root
      DATABASE_PASSWORD: Gukesh12garry@
      DATABASE_NAME: iris_systems_rec_task_development
    networks:
      - rails_network
    command: bash -lc "bundle _2.6.6_ exec rails s -b 0.0.0.0"


  app2:
    build: .
    container_name: rails-app2
    depends_on:
      - db
    environment:
      DATABASE_HOST: db
      DATABASE_USERNAME: root
      DATABASE_PASSWORD: Gukesh12garry@
      DATABASE_NAME: iris_systems_rec_task_development
    networks:
      - rails_network
    command: bash -lc "bundle _2.6.6_ exec rails s -b 0.0.0.0"


  app3:
    build: .
    container_name: rails-app3
    depends_on:
      - db
    environment:
      DATABASE_HOST: db
      DATABASE_USERNAME: root
      DATABASE_PASSWORD: Gukesh12garry@
      DATABASE_NAME: iris_systems_rec_task_development
    networks:
      - rails_network
    command: bash -lc "bundle _2.6.6_ exec rails s -b 0.0.0.0"

```
On running the command:
```
docker compose up -build
```

The application run successfully at
```
http://localhost
```
Where all the three rails application containers run successfully.



 
