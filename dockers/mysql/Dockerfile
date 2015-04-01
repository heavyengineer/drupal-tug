# http://txt.fliglio.com/2013/11/creating-a-mysql-docker-container/
FROM ubuntu

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -nfs /bin/true /sbin/initctl

#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get -y install mysql-server

# listen on all interfaces
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

RUN /usr/sbin/mysqld & \
    sleep 10s &&\
    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'changeme' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

# create a softlink to the host machine so we don't have to load an entire db each time (in case it's huge)
#RUN ln -s /vagrant/db /usr/local/mysql

EXPOSE 3306
    
CMD ["/usr/bin/mysqld_safe"]
