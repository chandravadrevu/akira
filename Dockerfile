FROM ubuntu:16.04

LABEL maintainer="chandra"
ENV DEBIAN_FRONTEND noninteractive
# Install basics:
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y vim && apt-get install -y software-properties-common && apt-get install -y language-pack-en-base && \
LC_ALL=en_US.UTF-8  add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y curl
# Install PHP 5.6:
RUN apt-get update
RUN apt-get install -y php-common libapache2-mod-php5.6 php5.6-mysql php5.6-mbstring php5.6-gd php5.6-curl php5.6-mcrypt php5.6-xdebug php5.6-dom
RUN apt-get install -y imagemagick && apt-get install -y gcc php5.6-imagick
# Manually set up the apache environment variables:
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
#copy files:
COPY files2copy/etc/apache2/apache2.conf /etc/apache2/apache2.conf
COPY files2copy/etc/apache2/sites-available/aspepublic-ssl.conf /etc/apache2/sites-available/aspepublic-ssl.conf
# Enable apache mods:
RUN a2enmod php5.6
RUN a2enmod rewrite
RUN a2enmod ssl
# Enable aspe site:
RUN a2ensite aspepublic-ssl
#install and start mysql
RUN apt-get -y install mysql-server
RUN apt-get install openssl
#install Solr:
RUN add-apt-repository ppa:openjdk-r/ppa && apt-get -y update && apt-get install -y openjdk-7-jre
RUN mkdir /usr/java && ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default
RUN apt-get install -y wget 


ENV SOLR_VERSION 4.5.1
ENV SOLR solr-$SOLR_VERSION     
RUN cd /opt && \
        wget http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
        tar -xvf $SOLR.tgz 
RUN mv /opt/$SOLR /opt/solr
RUN useradd --home-dir /opt/solr --comment "Solr Server" solr
RUN chown -R solr:solr /opt/solr/example
RUN mkdir -p /solr/apps/solr/home        
RUN ln -s /opt/solr/dist/ /solr/apps/solr/home/        

# Expose apache:
EXPOSE 80 443 3306 8080 8983
#copy mysql connection file:
COPY files2copy/var/www/aspe/docroot/sites/default/settings-local.inc /var/www/aspe/docroot/sites/default/settings-local.inc
COPY files2copy/etc/php/5.6/apache2/php.ini /etc/php/5.6/apache2/php.ini
#prepare run script:
COPY files2copy/run-script.sh run-script.sh
RUN chmod +x ./run-script.sh


# Update the default apache site with the config we created.
# ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
# RUN mkdir /var/www/Website && cp /var/www/html/index.* /var/www/Website/.

#map localdirs
# ADD /etc/apache2 /etc/apache
# ADD /var/www /var/www

# By default start up apache in the foreground, override with /bin/bash for interative.
#CMD /usr/sbin/apache2ctl -D FOREGROUND

CMD ./run-script.sh
