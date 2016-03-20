# Drupal Site Project with Docker
A template for local Drupal site project development with Docker.

# Getting started
Build the container
```
docker build -t drupal-web .
```

# Start your app with docker-compose
```
docker-compose up
```

> You should now be able to SSH to port 8022 with username as root and password as root.

> The webserver could be accessed on port 8080.

> The /project directory contains an example composer drupal project. The 'www' directory is the root directory of your drupal site which is added as a volume inside docker on /var/www.

## Database configuration
* Host: db
* User: root
* Password: password
* Database: drupal

# Stopping your app
```
docker-compose stop
```

# @Todo
Drush from outside docker.
