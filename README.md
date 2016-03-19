# Drupal Project with Docker
A project template for Drupal development with Docker.

# Getting started
Install the build helper.
```
npm install
```

# Build the container
```
npm run docker_build
```

# Start the container
```
npm run docker_start
```
You should now be able to SSH to port 8022 with username as root and password as root.

The webserver could be accessed on port 8080.

The /project directory contains an example composer drupal project. The 'www' directory is the root directory of your drupal site which is added as a volume inside docker on /var/www.

# Stop and remove container
```
npm run docker_stop
```
