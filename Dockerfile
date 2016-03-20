#Base Image
  FROM phusion/baseimage

#Maintainer
  MAINTAINER Marc Galang <marc.galang@live.com>

ENV DEBIAN_FRONTEND noninteractive

#Set locale settings
  RUN locale-gen en_US.UTF-8
  ENV LANG       en_US.UTF-8
  ENV LC_ALL     en_US.UTF-8

#Update packages
  RUN apt-get update -y

#Install common packages
  RUN apt-get install -y vim curl wget

#Add PHP from PPA repo
  RUN add-apt-repository -y ppa:ondrej/php5
  RUN apt-get update -y

#Install php and nginx
  RUN apt-get install -y --force-yes \
    php5-fpm php5-mysql php5-curl php5-gd php5-mcrypt nginx

#Add nginx configuration
ADD ./container_config/default /etc/nginx/sites-available/

#Install mysql
  RUN apt-get install -y mysql-client

#Install and setup ssh
  RUN apt-get install -y openssh-server

#Install supervisord
  RUN apt-get install -y supervisor

#Setup SSH
  RUN echo 'root:root' | chpasswd
  RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
  RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#Install Composer
  RUN curl -sS https://getcomposer.org/installer | php
  RUN mv composer.phar /usr/local/bin/composer

#Install Drupal tools (Drush & Drupal)
  RUN wget http://files.drush.org/drush.phar
  RUN mv drush.phar /usr/local/bin/drush && chmod +x /usr/local/bin/drush
  RUN curl http://drupalconsole.com/installer -L -o drupal.phar
  RUN mv drupal.phar /usr/local/bin/drupal && chmod +x /usr/local/bin/drupal
  RUN drupal init

#Setup supervisor services
  RUN echo '[program:nginx]\ncommand=/usr/sbin/nginx -g "daemon off;"\n\n' >> /etc/supervisor/supervisord.conf
  RUN echo '[program:sshd]\ncommand=/usr/sbin/sshd -D\n\n' >> /etc/supervisor/supervisord.conf
  RUN echo '[program:php5]\ncommand=/usr/sbin/php5-fpm -D\n\n' >> /etc/supervisor/supervisord.conf

#Export http and ssh
  Expose 80 22

#Apt cleanup
  RUN apt-get clean
  RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Start services
  CMD exec supervisord -n
