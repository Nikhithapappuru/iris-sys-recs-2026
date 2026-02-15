## Dockerising the application

Containerizing the Rails Application using a custom Dockerfile.

-Added the Dockerfile with required dependencies to ensure environment consistency, dependency isolation and reproducible builds.

### Dockerfile Overview:
 Base image:
ruby:3.4.1


Installed Packages:
- build-essential (compile native gems)
- nodejs (asset pipeline)
- npm
- default-mysql-client


### Layer Caching optimization:
```
COPY Gemfile Gemfile.lock ./
 
RUN gem install bundler -v 2.6.6
RUN bundle _2.6.6_ install

COPY . .
```
Docker builds in layers.

If application code changes but Gemfile doesn't:
- bundle install layer remains cached
- Build time is significantly reduced


### Entrypoint Script

Remove stale PID:

```
rm -f /app/tmp/pids/server.pid
```
Prevents the error  "A server is already running".

To delete the PID file from the host system so that the container start the other process 

Giving Execution permission to entrypoint.sh
```
chmod +x entrypoint.sh
```

Building the docker image:
```
docker build -t rails-app .
```
After the build is succeeded, run the container
```
docker run -p 8080:3000 rails-app
```
Host port: 8080
Container port: 3000

There was an error 
ActiveRecord: ConnectionNotEstablished

This is the error because the rails container is trying to connect to MYSQL on the host system, using 
socket:
``` /var/run/mysqld/mysqld.sock```

But inside the Docker , that socket file does not exist.
The container is isolated , so it cannot use the host MYSQL.

In the next task a seperate mysql container will be created and a network is created for the main application container and MYSQL Container for the connection so that the rails application can access the database.


