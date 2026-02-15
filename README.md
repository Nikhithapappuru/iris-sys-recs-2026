# docker-compose-setup

- Multi-container Architecture with Docker Compose
- The main objective of this task is to run Rails and MYSQL as seperate containers using Docker Compose

 A docker-compose.yml file is created with the services:
- app(Rails)
- db (MYSQL 8)
- Custom Bridge network


## Modified the configuration

Updated `database.yml` to use the environment variables:

```
host: <%= ENV["DATABASE_HOST"] %>
username: <%= ENV["DATABASE_USERNAME"] %>
password: <%= ENV["DATABASE_PASSWORD"] %>
database: <%= ENV["DATABASE_NAME"] %>
```

This is because the local host refers to container itself, so we must use Docker DNS hostname (db)

Running the docker-compose.yml file:
```
docker compose build
```
So the Rails app will be built , the network and the volumes will be created, MYSQL image will be pulled.
```
docker compose up
```
So the MYSQL container will be started, Rails container will be started, logs will be displayed and Rails will try to connect to MYSQL Container.

At the port 8080, we will access the application:

But an error ActiveRecord: PendingMigrationError arises.

This error arises because the MYSQL is not set up and the Rails is trying to make the connections before the MYSQL is ready.

Rails check the schema_migrations table to see if migrations were applied.
So inside the new MYSQL container:
→The DB is empty
→No tables exist
→No migrations applied
That is why there is an error


Now on running the command
```
docker compose run app rails db:migrate
```
The migrations will be applied , the db structure will be created.

On the command
```
docker compose up
```
The application will be running on the port 8080.

