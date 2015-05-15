############################################################
# Dockerfile to build apache container images
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu:trusty

# File Author / Maintainer
MAINTAINER steev@initsix.co.uk

RUN apt-get update
RUN apt-get -y upgrade

# install Supervisord which controls the apache and ssh daemons
# RUN apt-get install -y supervisor && mkdir -p /var/log/supervisor
# ADD	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# CMD ["/usr/bin/supervisord", "-n"]

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl mysql-client php5-memcached php5-xdebug
  
# # Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# # Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
RUN sed -i "s/display_errors = .*$/display_errors = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/memory_limit = .*$/memory_limit = 256M/" /etc/php5/apache2/php.ini

# configure xdebug
RUN sed -i "$ a xdebug.remote_enable=On" /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i "$ a xdebug.remote_connect_back=On" /etc/php5/apache2/conf.d/20-xdebug.ini
  
# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush
RUN composer global require drush/drush:dev-master

# add a vagrant user so the uids (should be 1000) match the vm for file sharing
RUN useradd vagrant
# # Manually set up the apache environment variables
ENV APACHE_RUN_USER vagrant
ENV APACHE_RUN_GROUP vagrant
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
#  
EXPOSE 80 443
#
# copy custom settings

# # Update the default apache site with the config we created.
ADD ./apache-config.config /etc/apache2/sites-enabled/000-default.conf

# Update the default apache site with the config we created.
ADD ./envvars /etc/apache2/envvars

# Update the default apache site with the config we created.
ADD ./apache-config.config /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
