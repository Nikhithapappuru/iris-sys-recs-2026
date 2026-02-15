# iris-sys-recs-2026
This repository contains my work for the IRIS Systems Team Recriutment Task 2026.
## Branches

- [dockerize]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/dockerize
- [docker-compose-setup]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/docker-compose-setup
- [nginx-proxy]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/nginx-proxy
- [load-balancing]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/load-balancing
- [persistence]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/persistence
- [rate-limiting]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/rate-limiting
- [monitoring]https://github.com/Nikhithapappuru/iris-sys-recs-2026/tree/monitoring

## Local Application Setup and Debugging

Before containerizing the Rails application, I verified and debugged the app locally. This will make sure the base application is stable and is in well working postion before Dockerization.

### Ruby Environment Setup (rbenv)

I have installed Ruby using rbenv, which allows version management.
Made a setup where i have installed rbenv, enabled it in the shell, installed Ruby 3.4.1, set it as default, and installed Bundler to manage gems.

Firstly, i have downloaded the rbenv souce code from the Github.
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```
Added rbenv to the path and appended it to ~/.bashrc

```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
```
Reloaded the .bashrc

```
source ~/.bashrc
```

To setup shims and Ruby version switching
```
rbenv init
```
Installed ruby-plugin for rbenv
```
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

Downloaded Ruby 3.4.1 source code
```
rbenv install 3.4.1
```
Set Ruby 3.4.1 as the default Ruby
```
rbenv global 3.4.1
```

Installed Bundler version 2.6.6 as required.
```
gem install bundler -v 2.6.6
```


### Bug found in the Gemfile

While running the `bundle install`, there was a Version mismatch.

**BUG:**

The Gemfile incorrectly specified:

```
gem 'activesupport', '~> 8.1', '>= 8.1.2'

gem 'activerecord', '~> 8.1', '>= 8.1.2'
```

Where these version are compatible with the Rails 7.0.10

Rails 7 requires 
--> activesupport 7.x
--> active record 7.x

Therefore the two lines from the Gemfile are removed.
```
bundle _2.6.6_ install
```
 After fixing , this resolved the dependency conflict.

 ### MYSQL Connection Error and Authentication modification.

 On running the command :
 ```
 rails db:create
```
it gave an error
```
Access denied for user 'root'@'localhost'
```
Becuase on UBUNTU/WSL , MYSQL installs with socket authentication type and accepts the root users without the passwords.
But Rails uses password authentication and therefore MYSQL ignored the password and rejected the rails even the socket path is mentioned in the default segment of database.yml file
```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: Gukesh12garry@
  socket: /var/run/mysqld/mysqld.sock
```
**FIX made :**
Converted root to mysql_native_password by altering it.
 ```
 sudo mysql
 ```
 ```
ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY 'yourpassword';
```
```
FLUSH PRIVILEGES;
```
```
EXIT;
```
and tested it by using password authentication.
```
mysql -u root -p
```

### Rails Database Setup and running the application locally:

After fixing MYSQL Authentication:

the commands 
```
rails db: create
```
and
```
rails db: migrate
```
executed succesfully.

I have started the rails server:
```
rails server
```
The application loaded successfully.



